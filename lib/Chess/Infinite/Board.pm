package Chess::Infinite::Board;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Hash::Util::FieldHash qw [fieldhash];

our $VERSION = '2019012901';


sub new ($class) {
    bless \do {my $var} => $class;
}

sub init ($self) {$self}

#
# Return whether a position is valid. Returns true by default.
# Must be overriden by boards which don't cover the plane.
#
sub is_valid ($self, $x, $y) {
    1;
}

1;

__END__
