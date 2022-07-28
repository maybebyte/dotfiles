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

use File::Basename;
use File::Temp;
use HTTP::Tiny;
use URI;
use OpenBSD::Pledge;
use v5.10; # say

pledge( qw(rpath tmppath fattr proc exec prot_exec dns inet) )
	or die "Pledge failed: $!\n";

my $program_name = fileparse $0;

my $url = shift // die "$program_name needs a URL.\n";
$url =~ s/\Ahttp:/https:/;
$url = URI->new($url);
$url->scheme eq 'https' or die "$program_name only supports the 'https' scheme.\n";


system 'command -v sxiv >/dev/null 2>&1';
die "sxiv is not installed.\n" if $?;

die "$program_name needs a graphical environment!\n" unless $ENV{'DISPLAY'};


my $tmpfile = File::Temp->new();
my $http = HTTP::Tiny->new(
	verify_SSL => 1,
);
die "No TLS support: $!\n" unless $http->can_ssl;

# No need for prot_exec anymore.
# ($http->can_ssl requires prot_exec).
pledge( qw(rpath tmppath fattr inet dns proc exec) )
	or die "Pledge failed: $!\n";

my $response = $http->get($url);

# No need for dns or inet anymore, as the request is stored.
pledge( qw(rpath tmppath fattr proc exec) )
	or die "Pledge failed: $!\n";

die "$response->{status} $response->{reason}\n" unless $response->{success};

open my $tmp_fh, '>', $tmpfile or die "$tmpfile could not be opened for writing: $!\n";
say $tmp_fh $response->{content};
close $tmp_fh or die "Could not close $tmpfile file handle: $!\n";

# Cannot be exec, since the temporary file needs to be cleaned up.
system 'sxiv', '--', $tmpfile;

# No need for exec or proc anymore.
pledge( qw(rpath tmppath fattr) ) or die "Pledge failed: $!\n";
