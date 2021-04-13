package ArrayDataRole::Source::LinesDATA;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny;
use Role::Tiny::With;
with 'ArrayDataRole::Spec::Basic';

sub new {
    no strict 'refs';

    my $class = shift;

    my $fh = \*{"$class\::DATA"};
    my $fhpos_data_begin = tell $fh;

    bless {
        fh => $fh,
        fhpos_data_begin => $fhpos_data_begin,
        index => 0, # iterator
    }, $class;
}

sub elem {
    my $self = shift;
    die "Out of range" if eof($self->{fh});
    chomp(my $elem = readline($self->{fh}));
    $self->{index}++;
    $elem;
}

sub get_elem {
    my $self = shift;
    return undef if eof($self->{fh});
    chomp(my $elem = readline($self->{fh}));
    $self->{index}++;
    $elem;
}

sub get_iterator_index {
    my $self = shift;
    $self->{index};
}

sub reset_iterator {
    my $self = shift;
    seek $self->{fh}, $self->{fhpos_data_begin}, 0;
    $self->{index} = 0;
}

1;
# ABSTRACT: Role to access array data from DATA section, one line per element

=for Pod::Coverage ^(.+)$

=head1 DESCRIPTION

This role expects array data in lines in the DATA section.


=head1 ROLES MIXED IN

L<ArrayDataRole::Spec::Basic>


=head1 SEE ALSO

Other C<ArrayDataRole::Source::*>

=cut
