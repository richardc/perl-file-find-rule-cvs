use strict;
package File::Find::Rule::CVS;
our $VERSION = '0.01';

=head1 NAME

File::Find::Rule::CVS - find files based on CVS metadata

=head1 SYNOPSIS

 use File::Find::Rule::CVS;
 my @modified = find( cvs_modified => in => 'sandbox' );

=head1 DESCRIPTION

File::Find::Rule::CVS extends File::Find::Rule to add clauses based on
the contents CVS/Entries files.

=cut

1;
__END__

