#!perl -w
use strict;
use Test::More tests => 1;
use File::Slurp::Tree;
use POSIX qw(strftime);

use File::Find::Rule::CVS;

# make a dummy sandbox
my $now = time;
my $past = $now - 60;
my $path = 't/sandbox';
spew_tree( $path => {
    CVS => {
        Entries => join( "",
                         map { # yuck
                             join( "/",
                                   '',
                                   $_->[0], $_->[1],
                                   strftime('%a %b %e %H:%M:%S %Y',
                                            gmtime $_->[2]),
                                   '', '' ) . "\n"
                         } ( [ 'same', '1.1',     $past ],
                             [ 'modified', '1.2', $past ]
                            )
                        ),

    },
    modified => "make like I'm modified\n",
    same    => "and I'll pretend to be the same\n",
});
ok( utime( $past, $past, "$path/same" ),     "touch same" );
ok( utime( $now,  $now,  "$path/modified" ), "touch modified" );

is_deeply( [ find( file => cvs_modified => relative => in => $path ) ],
           [ 'modified' ],
          "cvs_modified" );
