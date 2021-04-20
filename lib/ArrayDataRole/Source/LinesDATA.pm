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
