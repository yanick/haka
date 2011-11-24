
use strict;
use warnings;

use autodie;
use Path::Class;

# At least ices_get_next must be defined. And, like all perl modules, it
# must return 1 at the end.

# Function called to initialize your python environment.
# Should return 1 if ok, and 0 if something went wrong.

our $collection_dir = dir( $ENV{COLLECTION} )
    or die 'environment variable COLLECTION not set';

our $playlist_dir = dir( $ENV{PLAYLIST} )
    or die 'environment variable PLAYLIST not set';

sub ices_init {
	print "Perl subsystem Initializing:\n";
	return 1;
}

# Function called to shutdown your python enviroment.
# Return 1 if ok, 0 if something went wrong.
sub ices_shutdown {
	print "Perl subsystem shutting down:\n";
}

# Function called to get the next filename to stream. 
# Should return a string.
sub ices_get_next {
	print "Perl subsystem quering for new track:\n";

    if ( my ( $song ) = sort grep { !/\.gitdummy/ } $playlist_dir->children ) {
        print "playlist is present";
        my $file = file( $song )->slurp( chomp => 1 );
        unlink $song;
        return $file;
    }

    print "playlist empty, get one from the collection";
    my @files = grep { /\.mp3$/ } $collection_dir->children;
    return $files[ rand @files ];
}

# If defined, the return value is used for title streaming (metadata)
sub ices_get_metadata {
        return "Artist - Title (Album, Year)";
}

# Function used to put the current line number of
# the playlist in the cue file. If you don't care
# about cue files, just return any integer.
sub ices_get_lineno {
	return 1;
}

1;
