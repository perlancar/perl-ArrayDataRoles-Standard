package ArrayDataRole::Source::LinesInDATA;

use strict;
use Role::Tiny;
use Role::Tiny::With;
with 'ArrayDataRole::Spec::Basic';

# AUTHORITY
# DATE
# DIST
# VERSION

sub new {
    no strict 'refs'; ## no critic: TestingAndDebugging::RequireUseStrict

    my $class = shift;

    my $fh = \*{"$class\::DATA"};
    my $fhpos_data_begin;
    if (defined ${"$class\::_ArrayData_fhpos_data_begin_cache"}) {
        $fhpos_data_begin = ${"$class\::_ArrayData_fhpos_data_begin_cache"};
        seek $fh, $fhpos_data_begin, 0;
    } else {
        $fhpos_data_begin = ${"$class\::_ArrayData_fhpos_data_begin_cache"} = tell $fh;
    }

    bless {
        fh => $fh,
        fhpos_data_begin => $fhpos_data_begin,
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
    seek $self->{fh}, $self->{fhpos_data_begin}, 0;
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

sub fh_min_offset {
    my $self = shift;
    $self->{fhpos_data_begin};
}

sub fh_max_offset { undef }

1;
# ABSTRACT: Role to access array data from DATA section, one line per element

=for Pod::Coverage ^(.+)$

=head1 DESCRIPTION

This role expects array data in lines in the DATA section.

Note: C<get_item_at_pos()> and C<has_item_at_pos()> are slow (O(n) in worst
case) because they iterate. Caching might be added in the future to speed this
up.


=head1 ROLES MIXED IN

L<ArrayDataRole::Spec::Basic>


=head1 PROVIDED METHODS

=head2 fh

Returns the DATA filehandle.

=head2 fh_min_offset

Returns the starting position of DATA.

=head2 fh_max_offset

Returns C<undef>.


=head1 SEE ALSO

L<ArrayDataRole::Source::LinesInFile>

Other C<ArrayDataRole::Source::*>

=cut
