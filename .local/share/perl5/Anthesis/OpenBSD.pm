use v5.36;

package Anthesis::OpenBSD;
use Carp;
use English;
use Exporter qw(import);

# XXX: This adds both OpenBSD::Pledge and OpenBSD::Unveil to the module
# list, even if only one is used. Is there a way to programmatically
# determine if only one is needed?
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

our @EXPORT = qw();
our @EXPORT_OK = qw(pledge_or_die unveil_or_die);

sub pledge_or_die (@syscalls) {
	pledge @syscalls or croak "Pledge failed: $OS_ERROR";
}

sub unveil_or_die (%file_perms) {
	while ( my ( $file, $file_perms ) = each %file_perms ) {
		unveil $file, $file_perms or croak "Unveil failed: $OS_ERROR";
	}
}

1;
