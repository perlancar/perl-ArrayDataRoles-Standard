package ArrayData::Array;

use strict;
use warnings;

use Role::Tiny::With;
with 'ArrayDataRole::Source::Array';

# AUTHORITY
# DATE
# DIST
# VERSION

1;
# ABSTRACT: Get array data from Perl array

=head1 SYNOPSIS

 use ArrayData::Array;

 my $ary = ArrayData::Array->new(
     array => [1,2,3],
 );


=head1 DESCRIPTION

This is an C<ArrayData::> module to get array elements from a Perl array.


=head1 SEE ALSO

L<ArrayData>
