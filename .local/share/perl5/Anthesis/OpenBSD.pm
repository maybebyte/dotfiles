use v5.36;
use strict;
use warnings;

package Anthesis::OpenBSD;
use Carp;
use Exporter qw(import);

use OpenBSD::Pledge;
use OpenBSD::Unveil;

our @EXPORT = qw();
our @EXPORT_OK = qw(pledge_or_die unveil_or_die);

sub pledge_or_die {
	pledge(@_) or croak "Pledge failed: $!";
}

sub unveil_or_die {
	my $file = shift or croak 'Unveil failed: no file was provided';
	my $perms = shift or croak 'Unveil failed: no permissions were provided';
	unveil( $file, $perms ) or croak "Unveil failed: $!";
}

1;
