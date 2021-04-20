package ArrayDataRole::Source::Array;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use Role::Tiny;
use Role::Tiny::With;
with 'ArrayDataRole::Spec::Basic';

sub new {
    my ($class, %args) = @_;

    my $ary = delete $args{array} or die "Please specify 'array' argument";

    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;

    bless {
        array => $ary,
        pos => 0,
    }, $class;
}

sub get_next_item {
    my $self = shift;
    die "StopIteration" unless $self->{pos} < @{ $self->{array} };
    $self->{array}->[ $self->{pos}++ ];
}

sub has_next_item {
    my $self = shift;
    $self->{pos} < @{ $self->{array} };
}

sub reset_iterator {
    my $self = shift;
    $self->{pos} = 0;
}

sub get_iterator_pos {
    my $self = shift;
    $self->{pos};
}

1;
# ABSTRACT: Get array data from a Perl array

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 my $ary = ArrayData::Array->new(array => [1,2,3]);


=head1 DESCRIPTION

This role retrieves elements from a Perl array. It is basically an iterator.


=head1 ROLES MIXED IN

L<ArrayDataRole::Spec::Basic>


=head1 SEE ALSO

L<ArrayData>

=cut
