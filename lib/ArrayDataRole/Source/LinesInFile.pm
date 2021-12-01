package ArrayDataRole::Source::LinesInFile;

use strict;
use Role::Tiny;
use Role::Tiny::With;
with 'ArrayDataRole::Spec::Basic';

# AUTHORITY
# DATE
# DIST
# VERSION

sub new {
    my ($class, %args) = @_;

    my $fh;
    unless (defined($fh = delete $args{fh})) {
        my $filename = delete $args{filename};
        defined $filename or die "Please specify fh or filename";
        open  $fh, "<", $filename;
    }

    bless {
        fh => $fh,
        pos => 0, # iterator
    }, $class;
}

sub get_next_item {
    my $self = shift;
    die "StopIteration" if eof($self->{fh});
    chomp(my $elem = readline($self->{fh}));
    $self->{pos}++;
    $elem;
}

sub has_next_item {
    my $self = shift;
    !eof($self->{fh});
}

sub get_iterator_pos {
    my $self = shift;
    $self->{pos};
}

sub reset_iterator {
    my $self = shift;
    seek $self->{fh}, 0, 0;
    $self->{pos} = 0;
}

sub get_item_at_pos {
    my ($self, $pos) = @_;
    $self->reset_iterator if $self->{pos} > $pos;
    while (1) {
        die "Out of range" unless $self->has_next_item;
        my $item = $self->get_next_item;
        return $item if $self->{pos} > $pos;
    }
}

sub has_item_at_pos {
    my ($self, $pos) = @_;
    return 1 if $self->{pos} > $pos;
    while (1) {
        return 0 unless $self->has_next_item;
        $self->get_next_item;
        return 1 if $self->{pos} > $pos;
    }
}

sub fh {
    my $self = shift;
    $self->{fh};
}

1;
# ABSTRACT: Role to access array data from a file/filehandle, one line per element

=for Pod::Coverage ^(.+)$

=head1 DESCRIPTION

This role expects array data in lines from a file/filehandle.

Note: C<get_item_at_pos()> and C<has_item_at_pos()> are slow (O(n) in worst
case) because they iterate. Caching might be added in the future to speed this
up.


=head1 METHODS

=head2 new

Usage:

 my $ary = $CLASS->new(%args);

Arguments:

=over

=item * filename

Str. Either specify this or C<fh>.

=item * fh

Filehandle. Either specify this or C<filename>.

=back


=head1 ROLES MIXED IN

L<ArrayDataRole::Spec::Basic>


=head1 PROVIDED METHODS

=head2 fh

Returns the filehandle.

=head2 fh_min_offset

Returns the starting position of DATA.

=head2 fh_max_offset

Returns C<undef>.


=head1 SEE ALSO

L<ArrayDataRole::Source::LinesInDATA>

Other C<ArrayDataRole::Source::*>

=cut
