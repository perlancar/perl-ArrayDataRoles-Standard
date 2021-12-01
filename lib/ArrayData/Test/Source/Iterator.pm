package ArrayData::Test::Source::Iterator;

use strict;
use 5.010001;
use strict;
use warnings;
use Role::Tiny::With;
with 'ArrayDataRole::Source::Iterator';

# AUTHORITY
# DATE
# DIST
# VERSION

sub new {
    my ($class, %args) = @_;
    $args{num_elems} //= 10;
    $args{random}    //= 0;

    $class->_new(
        gen_iterator => sub {
            my $i = 0;
            sub {
                $i++;
                return undef if $i > $args{num_elems}; ## no critic: Subroutines::ProhibitExplicitReturnUndef
                return $args{random} ? int(rand()*$args{num_elems} + 1) : $i;
            };
        },
    );
}

1;
# ABSTRACT: A test ArrayData module

=head1 SYNOPSIS

 use ArrayData::Test::Source::Iterator;

 my $ary = ArrayData::Test::Soure::Iterator->new(
     # num_rows => 100,   # default is 10
     # random => 1,       # if set to true, will return elements in a random order
 );


=head1 DESCRIPTION

=head2 new

Create object.

Usage:

 my $ary = ArrayData::Test::Source::Iterator->new(%args);

Known arguments:

=over

=item * num_elems

Positive int. Default is 10.

=item * random

Bool. Default is 0.

=back
