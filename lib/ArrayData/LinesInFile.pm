package ArrayData::LinesInFile;

use strict;
use warnings;

use Role::Tiny::With;
with 'ArrayDataRole::Source::LinesInFile';

# AUTHORITY
# DATE
# DIST
# VERSION

1;
# ABSTRACT: Get array data from a file/filehandle, one line per element

=head1 SYNOPSIS

 use ArrayData::LinesInFile;

 my $ary = ArrayData::LinesInFile->new(
     filename => '/path/to/foo', # either specify filename, or 'fh', e.g. fh => \*STDIN,
 );


=head1 DESCRIPTION

This is an C<ArrayData::> module to get array elements from lines of a
file/filehandle.


=head1 SEE ALSO

L<ArrayData>
