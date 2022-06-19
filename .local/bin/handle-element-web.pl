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

# Extract the release tarball.
use Archive::Tar;

# Decode JSON and manipulate it with Perl.
use JSON::MaybeXS;

# Make an API request and download the release + detached signature.
#
# HTTP::Tiny did not play nice with GitHub's API, as it kept returning
# '400 Bad Request'. If there is a way to make HTTP::Tiny work, that
# would be my preference over LWP::UserAgent due to the latter's size.
use LWP::UserAgent;

# Create temporary directories.
use Path::Tiny;


sub make_api_url {
	my ($username, $repository) = @_;

	($username) || die '$username is undefined';
	($repository) || die '$repository is undefined';

	return "https://api.github.com/repos/$username/$repository/releases/latest";
}


sub make_release_url {
	my ($username, $repository, $version) = @_;

	($username) || die '$username is undefined';
	($repository) || die '$repository is undefined';
	($version) || die '$version is undefined';

	return "https://github.com/$username/$repository/releases/download/$version";
}


# GnuPG is required to cryptographically verify element-web.
#
# There is not a good way to verify signatures in Perl as far as I can
# tell. The Crypt::OpenPGP and GnuPG modules from CPAN both had issues.
system "which gpg >/dev/null 2>&1";
($? == 0) || die "GnuPG is not installed";


my $element_web_ui_dir;

# $element_web_ui_dir can be changed by modifying it in the environment:
# element_web_ui_dir=/path/to/dir handle-element-web.pl
if ($ENV{'element_web_ui_dir'}) {
	$element_web_ui_dir = "$ENV{'element_web_ui_dir'}";
} else {
	$element_web_ui_dir = '/var/www/htdocs/element-web';
}

# Try to change directory now and quit early if it fails, before
# downloading anything. Quitting after is a waste.
chdir "$element_web_ui_dir" || die "Failed to change directory to $element_web_ui_dir";


my $user_agent = LWP::UserAgent->new(
	protocols_allowed => [ 'https' ],
);

my $api_url = make_api_url 'vector-im', 'element-web';
my $api_response = $user_agent->get($api_url);

($api_response->is_success) || die $api_response->status_line;


my $decoded_json = decode_json $api_response->decoded_content;
my $remote_version = ${$decoded_json}{'name'};

# Exclude release candidates and catch unknown release schemes.
($remote_version =~ m/^v(\d)+\.(\d)+\.(\d)+$/)
	|| die "Release version did not match expected release scheme";


open my $local_version_fh, '<', "$element_web_ui_dir/element/version"
	|| die "Could not open $element_web_ui_dir/element/version";

my $local_version = <$local_version_fh>;
close $local_version_fh;

# Set up $local_version for comparison against $remote_version.
chomp $local_version;
$local_version = "v$local_version";

($remote_version gt $local_version)
	|| die "Remote version of element-web is not newer than local version";


my $release_url = make_release_url 'vector-im', 'element-web', "$remote_version";
my $tmpdir = Path::Tiny->tempdir;

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

($? == 0) || die <<'EOF';
GPG verification failed. Make sure the public key mentioned in
https://github.com/vector-im/element-web#getting-started is in
the key ring.
EOF


my $tar = Archive::Tar->new;
$tar->extract_archive("$tmpdir/element-$remote_version.tar.gz");


unlink "$element_web_ui_dir/element"
	|| die "Failed to remove $element_web_ui_dir/element";

# Symbolic link has to made with a relative path. Otherwise httpd(8)
# will return a 404, because it cannot see anything outside of
# /var/www.
symlink "./element-$remote_version", "./element"
	|| die "Failed to create a symbolic link";
