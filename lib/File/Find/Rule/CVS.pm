use strict;
package File::Find::Rule::CVS;
use File::Find::Rule;
use Parse::CVSEntries;
use base 'File::Find::Rule';
use vars qw( $VERSION );
$VERSION = '0.01';

=head1 NAME

File::Find::Rule::CVS - find files based on CVS metadata

=head1 SYNOPSIS

 use File::Find::Rule::CVS;
 my @modified = find( cvs_modified => in => 'sandbox' );

=head1 DESCRIPTION

File::Find::Rule::CVS extends File::Find::Rule to add clauses based on
the contents CVS/Entries files.

=cut

sub File::Find::Rule::_cvs_entry {
    my $self = shift;
    my ($file, $path) = @_;

    return $self->{_entries}{ $path }{ $file }
      if exists $self->{_entries}{ $path };

    my $parse = Parse::CVSEntries->new( "$path/CVS/Entries" )
      or return;

    $self->{_entries}{ $path } = { map { $_->name => $_ } $parse->entries };
    return $self->{_entries}{ $path }{ $file };
}

sub File::Find::Rule::cvs_modified () {
    my $self = shift()->_force_object;
    my $sub = sub {
        my $entry = $self->_cvs_entry( @_ ) or return;
        return (stat $_)[9] > $entry->mtime;
    };
    $self->exec( $sub );
}

1;
__END__

=head1 SEE ALSO

L<Parse::CVSEntries>, L<File::Find::Rule>

=cut
