use v5.36;
use strict;
use warnings;

package Anthesis::Dotfiles;
use Carp;
use Exporter qw(import);

our @EXPORT = qw();
our @EXPORT_OK = qw(import_pywal_colors);

sub import_pywal_colors {
	my $colors_file = shift or croak 'import_pywal_colors needs a colors file';
	my $colors_hashref;

	-e $colors_file or croak "pywal colors file ($colors_file) doesn't exist";
	-f _ or croak "pywal colors file ($colors_file) isn't a file";
	-r _ or croak "pywal colors file ($colors_file) isn't readable";

	open my $colors_fh, '<', $colors_file
		or croak "pywal colors file ($colors_file) couldn't be opened: $!";

	my $color_num = 0;
	while ( my $color = readline $colors_fh ) {
		chomp $color;
		next unless $color =~ /\A \# [0-9a-f]{6} \z/ix;

		$colors_hashref->{'color' . $color_num} = $color;
		$colors_hashref->{background} = $color if $color_num == 0;
		$colors_hashref->{foreground} = $color if $color_num == 15;
		++$color_num;
	}

	close $colors_fh
		or croak "pywal colors file ($colors_file) couldn't be closed: $!";

	return $colors_hashref;
}

1;
