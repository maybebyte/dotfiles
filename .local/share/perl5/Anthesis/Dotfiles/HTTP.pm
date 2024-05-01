use v5.36;
use strict;
use warnings;

package Anthesis::Dotfiles::HTTP;
use Carp;
use Exporter qw(import);
use HTTP::Tiny;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);

our @EXPORT = qw();
our @EXPORT_OK = qw(decompress_response gzipped_http regular_http);

sub decompress_response {
	my $response = shift or croak 'decompress_response needs a response';

	if ( exists $response->{headers}
		&& exists $response->{headers}{'content-encoding'}
		&& $response->{headers}{'content-encoding'} eq 'gzip' )
	{
		my $content = $response->{content};
		my $decompressed_content;

		gunzip( \$content => \$decompressed_content, )
			or croak "gunzip: $GunzipError";

		$response->{content} = $decompressed_content;
	}

	return $response;
}

sub regular_http {
	my %options = @_;

	my $http = HTTP::Tiny->new(
		verify_SSL => 1,
		%options,
	);

	$http->can_ssl or die "TLS is unsupported: $!";
	return $http;
}

sub gzipped_http {
	my $http = regular_http(
		default_headers => { 'Accept-Encoding' => 'gzip' }
	);
	return $http;
}

1;
