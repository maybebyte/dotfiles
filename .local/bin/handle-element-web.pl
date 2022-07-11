#!/usr/bin/env perl
# Copyright (c) 2022 Ashlen <eurydice@riseup.net>

# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.

# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

use strict;
use warnings;
use v5.14; # character interpretation

# Extract the release tarball.
use Archive::Tar;

# Create temporary directories.
use File::Temp;

# Decode JSON and manipulate it with Perl.
use JSON::MaybeXS;

# Make an API request and download the release + detached signature.
#
# HTTP::Tiny did not play nice with GitHub's API, as it kept returning
# '400 Bad Request'. If there is a way to make HTTP::Tiny work, that
# would be my preference over LWP::UserAgent due to the latter's size.
use LWP::UserAgent;


sub make_api_url {
	my ($username, $repository) = @_;

	$username or die '$username is undefined';
	$repository or die '$repository is undefined';

	return "https://api.github.com/repos/$username/$repository/releases/latest";
}


sub make_release_url {
	my ($username, $repository, $version) = @_;

	$username or die '$username is undefined';
	$repository or die '$repository is undefined';
	$version or die '$version is undefined';

	return "https://github.com/$username/$repository/releases/download/$version";
}


# GnuPG is required to cryptographically verify element-web.
#
# There is not a good way to verify signatures in Perl as far as I can
# tell. The Crypt::OpenPGP and GnuPG modules from CPAN both had issues.
system "command -v gpg >/dev/null 2>&1";
$? == 0 or die "GnuPG is not installed\n";


# $element_web_ui_dir can be changed by modifying it in the environment:
# ELEMENT_WEB_UI_DIR=/path/to/dir handle-element-web.pl
my $element_web_ui_dir = $ENV{'ELEMENT_WEB_UI_DIR'} // '/var/www/htdocs/element-web';

# Try to change directory now and quit early if it fails, before
# downloading anything. Quitting after is a waste.
chdir "$element_web_ui_dir" or die "Failed to change directory to $element_web_ui_dir: $!";


my $user_agent = LWP::UserAgent->new(
	protocols_allowed => [ 'https' ],
);

my $api_response = $user_agent->get(make_api_url('vector-im', 'element-web'));
$api_response->is_success or die $api_response->status_line;


my $decoded_json = decode_json $api_response->decoded_content;
my $remote_version = ${$decoded_json}{'name'};

# Exclude release candidates and catch unknown release schemes.
$remote_version =~ /\A v \d+\. \d+\. \d+ \z/ax
	or die "Release version did not match expected release scheme.\n";


open my $local_version_fh, '<', "$element_web_ui_dir/element/version"
	or die "Could not open $element_web_ui_dir/element/version: $!";

chomp(my $local_version = 'v' . <$local_version_fh>);
close $local_version_fh;

$remote_version gt $local_version
	or die "Remote version of element-web is not newer than local version.\n";


my $release_url = make_release_url 'vector-im', 'element-web', $remote_version;
my $tmpdir = File::Temp->newdir;

$user_agent->mirror(
	"$release_url/element-$remote_version.tar.gz",
	"$tmpdir/element-$remote_version.tar.gz",
);

$user_agent->mirror(
	"$release_url/element-$remote_version.tar.gz.asc",
	"$tmpdir/element-$remote_version.tar.gz.asc",
);


system "gpg --verify $tmpdir/element-$remote_version.tar.gz.asc \\
	$tmpdir/element-$remote_version.tar.gz >/dev/null 2>&1";

$? == 0 or die <<'EOF';
GPG verification failed. Make sure the public key mentioned in
https://github.com/vector-im/element-web#getting-started is in
the key ring.
EOF


my $tar = Archive::Tar->new;
$tar->extract_archive("$tmpdir/element-$remote_version.tar.gz");


unlink "$element_web_ui_dir/element"
	or die "Failed to remove $element_web_ui_dir/element: $!";

# Symbolic link has to made with a relative path. Otherwise httpd(8)
# will return a 404, because it cannot see anything outside of
# /var/www.
symlink "./element-$remote_version", "./element"
	or die "Failed to create a symbolic link: $!";
