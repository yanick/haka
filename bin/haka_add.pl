#!/usr/bin/perl 

use 5.10.0;

use strict;
use warnings;

use LWP::UserAgent;
use Path::Class;

my ( $haka_home, @songs ) = @ARGV;

my $agent = LWP::UserAgent->new;

while ( my $song = shift @songs ) {
    $song = file( $song );
    print "adding '$song' to haka...";

    if ( $agent->get( "$haka_home/collection/".$song->basename )->is_success ) {
        say "song already present, no need to upload";
        $agent->post( "$haka_home/playlist", {
            song => $song->basename
        }
        )->is_success or die "adding to playlist failed";
    }
    else {
        $agent->post( "$haka_home/collection", 
            Content_Type => 'form-data',
            Content      => [ 
                song => [ ''.$song->relative ],
            ],
        )->is_success or die "upload failed";
    }
    say 'done';
}
