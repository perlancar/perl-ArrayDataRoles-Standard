package ArrayDataRole::Source::Iterator;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use Role::Tiny;
use Role::Tiny::With;
with 'ArrayDataRole::Spec::Basic';

sub _new {
    my ($class, %args) = @_;

    my $gen_iterator = delete $args{gen_iterator} or die "Please specify 'gen_iterator' argument";
    my $gen_iterator_params = delete $args{gen_iterator_params} // {};

    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;

    bless {
        gen_iterator => $gen_iterator,
        gen_iterator_params => $gen_iterator_params,
        iterator => undef,
        pos => 0,
        # buf => '', # exists when there is a buffer
    }, $class;
}

sub get_next_item {
    my $self = shift;
    $self->reset_iterator unless $self->{iterator};
    if (exists $self->{buf}) {
        $self->{pos}++;
        return delete $self->{buf};
    } else {
        my $elem = $self->{iterator}->();
        die "StopIteration" unless defined $elem;
        $self->{pos}++;
        return $elem;
    }
}

sub has_next_item {
    my $self = shift;
    if (exists $self->{buf}) {
        return 1;
    }
    $self->reset_iterator unless $self->{iterator};
    my $elem = $self->{iterator}->();
    return 0 unless defined $elem;
    $self->{buf} = $elem;
    1;
}

sub reset_iterator {
    my $self = shift;
    $self->{iterator} = $self->{gen_iterator}->(%{ $self->{gen_iterator_params} });
    $self->{pos} = 0;
}

sub get_iterator_pos {
    my $self = shift;
    $self->{pos};
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

1;
# ABSTRACT: Get array data from an iterator

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 package ArrayData::YourArray;
 use Role::Tiny::With;
 with 'ArrayDataRole::Source::Iterator';

 sub new {
     my $class = shift;
     $class->_new(
         gen_iterator => sub {
             return sub {
                 ...
             };
         },
     );
 }


=head1 DESCRIPTION

This role retrieves elements from a simplistic iterator (a coderef). When
called, the iterator must return a non-undef element or undef to signal that all
elements have been iterated.

C<reset_iterator()> will regenerate a new iterator.


=head1 METHODS

=head2 _new

Create object. This should be called by a consumer's C<new>. Usage:

 my $ary = $CLASS->_new(%args);

Arguments:

=over

=item * gen_iterator

Coderef. Required. Must return another coderef which is the iterator.

=back


=head1 ROLES MIXED IN

L<ArrayDataRole::Spec::Basic>


=head1 SEE ALSO

L<ArrayData>

=cut
