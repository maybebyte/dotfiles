use v5.36;
use strict;
use warnings;

package Anthesis::OpenBSD::Pledge;
use Carp;
use Exporter qw(import);
use OpenBSD::Pledge;

our @EXPORT = qw();
our @EXPORT_OK = qw(pledge_or_die);

sub pledge_or_die {
	pledge(@_) or croak "Pledge failed: $!";
}

1;
