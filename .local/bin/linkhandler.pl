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

# TODO:
# xclip could potentially be replaced with a Perl equivalent.
# yt-dlp invocations could leave the tty open after exiting.
# may not need fzf (although it does make things easy).

use strict;
use warnings;

use feature "say";

# Determine program name.
use File::Basename;

# make_path
use File::Path;

# catdir
use File::Spec;

# Bidirectional interprocess communication.
use IPC::Open2;

# Perform web requests.
use HTTP::Tiny;

# Escape URIs and otherwise manipulate them.
use URI;

my $program_name = fileparse $0;

my @dependencies = (
	'fzf',
	'mpv',
	'notify-send',
	'sxiv',
	'xclip',
	'yt-dlp',
);

my @options = (
	'copy duration',
	'copy title',
	'download audio',
	'download file',
	'download video',
	'listen',
	'print duration',
	'print title',
	'read',
	'view image',
	'watch',
	'watch (loop)',
);


chomp(my $url = $ARGV[0] // <STDIN>);
die "$program_name needs a URL!\n" unless $url;

$url = URI->new($url);
die "$program_name only handles the 'https' scheme.\n"
	unless $url->scheme eq 'https';


# Is there a portable way to do this that doesn't involve shell?
open my $sh_fh, '-|',
	"for dependency in @dependencies; do command -v \${dependency}; done";

my @dependency_checks;
while (<$sh_fh>) {
	chomp;
	push @dependency_checks, $_;
}

if ($#dependencies != $#dependency_checks) {
	my $count = 0;
	while (<@dependencies>) {
		$dependency_checks[$count] =~ /$_/
			or die "$_ is not installed!\n";
		$count++;
	}
}

close $sh_fh or die "Could not close shell filehandle: $!\n";


my $fzf_pid = open2(my $fzf_out, my $fzf_in, 'fzf')
	or die "Failed to run fzf: $!\n";

say $fzf_in join "\n", @options;
chomp(my $option = <$fzf_out> // die "Option must be defined.\n");

close $fzf_out or die "Could not close fzf filehandle: $!\n";
close $fzf_in or die "Could not close fzf filehandle: $!\n";
waitpid $fzf_pid, 0;


if ($option eq 'copy duration') {
	open my $yt_dlp_fh, '-|', 'yt-dlp', '--get-duration', '--', $url
		or die "Could not run yt-dlp: $!\n";

	chomp(my $duration = <$yt_dlp_fh> // die "No duration.\n");

	close $yt_dlp_fh or die "Could not close yt-dlp filehandle: $!\n";
	die "yt-dlp: non-zero exit of $?" if $?;


	open my $xclip_fh, '|-', 'xclip', '-selection', 'clipboard'
		or die "Could not send duration to xclip: $!\n";

	print $xclip_fh $duration;

	close $xclip_fh or die "Could not close xclip filehandle: $!\n";
	die "xclip: non-zero exit of $?" if $?;


	exec 'notify-send', '--', "Copied video duration: ($duration).";
	die "exec 'notify-send' failed: $!\n";
}

elsif ($option eq 'copy title') {
	open my $yt_dlp_fh, '-|', 'yt-dlp', '-e', '--', $url
		or die "Could not run yt-dlp: $!\n";

	chomp(my $title = <$yt_dlp_fh> // die "No title.\n");

	close $yt_dlp_fh or die "Could not close yt-dlp filehandle: $!\n";
	die "yt-dlp: non-zero exit of $?" if $?;


	open my $xclip_fh, '|-', 'xclip', '-selection', 'clipboard'
		or die "Could not send duration to xclip: $!\n";

	print $xclip_fh $title;

	close $xclip_fh or die "Could not close xclip filehandle: $!\n";
	die "xclip: non-zero exit of $?" if $?;


	exec 'notify-send', '--', "Copied video title: ($title).";
	die "exec 'notify-send' failed: $!\n";
}

elsif ($option eq 'download audio') {
	exec 'tmux', 'new-window', 'yt-dlp', '-xf', 'bestaudio/best', '--', $url;
	die "exec 'tmux new-window yt-dlp' failed: $!\n";
}

elsif ($option eq 'download file') {
	chdir or die "Could not change directory to HOME: $!\n";

	my $http = HTTP::Tiny->new(
		verify_SSL => 1,
	);
	die "TLS is unsupported: $!\n" unless $http->can_ssl;

	my $response = $http->get($url);
	die "$response->{status} $response->{reason}" unless $response->{success};

	my @uri_segments = $url->path_segments;
	my $host = $url->authority;

	my $dir_to_write_to = File::Spec->catdir('Downloads', $host);

	unless (-e $dir_to_write_to) {
		File::Path->make_path($dir_to_write_to)
			or die "Could not create directory named '$dir_to_write_to': $!\n";
	}

	chdir $dir_to_write_to
		or die "Could not change directory to '$dir_to_write_to': $!\n";

	open my $download_fh, '>', $uri_segments[-1]
		or die "Could not open file named '$uri_segments[-1]': $!\n";

	say $download_fh $response->{content};

	close $download_fh or die "Could not close filehandle: $!\n";
}

elsif ($option eq 'download video') {
	exec 'tmux', 'new-window', 'yt-dlp', '--', $url;
	die "exec 'tmux new-window yt-dlp' failed: $!\n";
}

elsif ($option eq 'listen') {
	exec 'tmux', 'new-window', 'mpv', '--no-resume-playback',
		'--no-keep-open', '--no-pause', '--no-video', '--', $url;

	die "exec 'tmux new-window mpv' failed: $!\n";
}

elsif ($option eq 'print duration') {
	open my $yt_dlp_fh, '-|', 'yt-dlp', '--get-duration', '--', $url
		or die "Could not run yt-dlp: $!\n";

	chomp(my $duration = <$yt_dlp_fh> // die "Nonexistent duration.\n");

	close $yt_dlp_fh or die "Could not close yt-dlp filehandle: $!\n";
	die "yt-dlp non-zero exit of $?" if $?;

	exec 'notify-send', '--', "Video duration: ($duration).";
	die "exec 'notify-send' failed: $!\n";
}

elsif ($option eq 'print title') {
	open my $yt_dlp_fh, '-|', 'yt-dlp', '-e', '--', $url
		or die "Could not run yt-dlp: $!\n";

	chomp(my $title = <$yt_dlp_fh> // die "No title.\n");

	close $yt_dlp_fh or die "Could not close yt-dlp filehandle: $!\n";
	die "yt-dlp: non-zero exit of $?" if $?;

	exec 'notify-send', '--', "Video title: ($title).";
	die "exec 'notify-send' failed: $!\n";
}

elsif ($option eq 'read') {
	my $http = HTTP::Tiny->new(
		verify_SSL => 1,
	);
	die "TLS is unsupported: $!\n" unless $http->can_ssl;

	my $response = $http->get($url);
	die "$response->{status} $response->{reason}" unless $response->{success};

	open my $zathura_fh, '|-', 'zathura', '-'
		or die "Could not run zathura: $!\n";

	say $zathura_fh $response->{content};

	close $zathura_fh or die "Could not close zathura filehandle: $!\n";
	die "zathura: non-zero exit of $?" if $?;
}

elsif ($option eq 'view image') {
	exec 'viewimg.pl', $url;
	die "exec 'viewimg.pl' failed: $!\n";
}

elsif ($option eq 'watch') {
	exec 'tmux', 'new-window', 'mpv', '--', $url;
	die "exec 'tmux new-window mpv' failed: $!\n";
}

elsif ($option eq 'watch (loop)') {
	exec 'tmux', 'new-window', 'mpv', '--loop', '--', $url;
	die "exec 'tmux new-window mpv' failed: $!\n";
}

else {
	die "$program_name doesn't support that option.\n";
}
