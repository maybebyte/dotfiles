#!/usr/bin/env perl
# Copyright (c) 2023 Ashlen <dev@anthes.is>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# Version (strictures implicitly included) and autodie pragma.
use v5.36;
use autodie;

# UTF-8 support.
use feature qw(unicode_strings);
use open qw(:std :encoding(UTF-8));
use utf8;
use warnings qw(FATAL utf8);

# Core modules.
use English;
use Unicode::Normalize qw(normalize);

BEGIN {
	if ( $OSNAME eq 'openbsd' ) {
		require OpenBSD::Pledge;
		require OpenBSD::Unveil;
		OpenBSD::Pledge->import('pledge');
		OpenBSD::Unveil->import('unveil');
	}
	else {
		sub pledge { return 1; }
		sub unveil { return 1; }
	}
}

sub pledge_or_die (@syscalls) {
	pledge @syscalls or die "Pledge failed: $OS_ERROR";
}

sub unveil_or_die (%file_perms) {
	while ( my ( $file, $file_perms ) = each %file_perms ) {
		unveil $file, $file_perms or die "Unveil failed: $OS_ERROR";
	}
}

unveil_or_die map { $ARG, 'r' } @INC;
pledge_or_die qw(rpath);
