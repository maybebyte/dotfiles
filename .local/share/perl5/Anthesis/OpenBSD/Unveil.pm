use v5.36;
use strict;
use warnings;

package Anthesis::OpenBSD::Unveil;
use Carp;
use Exporter qw(import);
use OpenBSD::Unveil;

our @EXPORT = qw();
our @EXPORT_OK = qw(unveil_or_die);

sub unveil_error {
	my $error_msg = shift or die 'unveil_error needs a valid error message';
	croak "Unveil failed: $error_msg";
}

sub unveil_or_die {
	my $file = shift or unveil_error 'missing file';
	my $perms = shift or unveil_error 'missing permissions';
	unveil( $file, $perms ) or unveil_error $!;
}

1;
