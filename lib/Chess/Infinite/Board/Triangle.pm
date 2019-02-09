package Chess::Infinite::Board::Triangle;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

our $VERSION = '2019012901';

use Chess::Infinite::Board;
our @ISA = qw [Chess::Infinite::Board];

use List::Util qw [max];
use POSIX      qw [ceil];


################################################################################
#
# to_value ($self, $x, $y)
#
# Given coordinates ($x, $y), return the corresponding value.
#
#    IN:  - $self: Current object
#         - $x:    X-coordinate, 0-based
#         - $y:    Y-coordinate, 0-based
#
#   OUT:  Value on position ($x, $y)
#
#   PRE:  $x >= 0 && $y >= 0
#
# TESTS:  100-Board/110-Triangle/100-to_value.t
#
################################################################################

sub to_value ($self, $x, $y) {
    my $z = ($x + $y) + 1;
    ($z * $z + $z) / 2 - $x;
}


################################################################################
#
# to_coordinates ($self, $value)
#
# Given a value, return the coordinates the value is on.
#
#    IN:  - $self:  Current object
#         - $value: Value we want coordinates for
#
#   OUT:  Position; in list context this is returned as a two element list;
#         in scalar context, this is returned as a reference to a two
#         element array.
#
#   PRE:  $value > 0
#
# TESTS:  100-Board/110-Triangle/100-to_value.t
#
################################################################################

sub to_coordinates ($self, $value) {
    #
    # The 'inverse' of the next triangle number
    #
    my $next_tn_inv = ceil ((sqrt (8 * $value + 1) - 1) / 2);
    my $next_tn     = ($next_tn_inv * $next_tn_inv + $next_tn_inv) / 2;

    my $x = $next_tn - $value;
    my $y = $next_tn_inv - $x - 1;

    wantarray ? ($x, $y) : [$x, $y];
}

################################################################################
#
# is_valid ($self, $x, $y)
#
# Given a set of coordinates ($x, $y), return whether it is "on the board".
# For our board, this means neither of the coordinates my be less than 0.
#
#    IN:  - $self: Current object
#         - $x:    X-coordinate, 0-based
#         - $y:    Y-coordinate, 0-based
#
#   OUT:  True if the coordinates are on the board, false otherwise.
#
# TESTS:  100-Board/110-Triangle/110-is_valid.t
#
################################################################################

sub is_valid ($self, $x, $y) {
    return $x >= 0 && $y >= 0;
}


1;

__END__
