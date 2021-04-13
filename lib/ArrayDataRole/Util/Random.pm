package ArrayDataRole::Util::Random;

# AUTHORITY
# DATE
# DIST
# VERSION

# enabled by Role::Tiny
#use strict;
#use warnings;

use Role::Tiny;

requires 'reset_iterator';
requires 'get_elem';

sub get_rand_elems {
    my ($self, $num_elems) = @_;
    my @elems;
    my $i = -1;
    $self->reset_iterator;
    while (defined(my $elem = $self->get_elem)) {
        $i++;
        if (@elems < $num_elems) {
            # we haven't reached $num_elems, insert elem to array in a random
            # position
            splice @elems, rand(@elems+1), 0, $elem;
        } else {
            # we have reached $num_elems, just replace an elem randomly, using
            # algorithm from Learning Perl, slightly modified
            rand($i+1) < @elems and splice @elems, rand(@elems), 1, $elem;
        }
    }
    \@elems;
}

sub get_rand_elem {
    my $self = shift;
    my $rows = $self->get_rand_elems(1);
    $rows ? $rows->[0] : undef;
}

1;
# ABSTRACT: Provide utility methods related to getting random elment(s)

=head1 DESCRIPTION

This role provides some utility methods related to getting random element(s)
from the array. Note that the methods perform a full, one-time, scan of the
array using C<get_elem>. For huge array, this might not be a good idea. Seekable
array can use the more efficient L<ArrayDataRole::Util::Random::Seekable>.


=head1 PROVIDED METHODS

=head2 get_rand_elem

Usage:

 my $elem = $ary->get_rand_elem; # might return undef

Get a single random element from the array. If array is empty, will return
undef.

=head2 get_rand_elems

Usage:

 my $elems = $ary->get_rand_elems($n);

Get C<$n> random elements from the array. No duplicate elements (doesn't mean
there won't be any duplicates, if the array originally contains duplicates). If
array contains less than C<$n> elements, only that many elements will be
returned.


=head1 SEE ALSO

L<ArrayDataRole::Util::Random::Seekable>

Other C<ArrayDataRole::Util::*>

L<ArrayData>
