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

#
# Given some coordinates, return the corresponding value.
#
sub to_value ($self, $x, $y) {
    my $z = ($x + $y) + 1;
    ($z * $z + $z) / 2 - $x;
}



#
# Given a value, return the corresponing coordinates.
#
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


sub is_valid ($self, $x, $y) {
    $x >= 0 && $y >= 0;
}


1;

__END__
