package Chess::Infinite::Piece::Leaper;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


################################################################################
# 
# target ($self)
#
# target calculates where the current piece should move to, given
# its current location, and which fields are blocked (by previous moves).
# The blocked fields are stored in the board object. 
#
# This method is board agnostic; it will ask the board which positions
# are valid (if the board doesn't cover the plane, some positions will
# be invalid). The piece is supposed to track where it has been.
#
#  IN:  $self:  Current object
#
# OUT:  false if the piece cannot move; else a two element array
#       with an x and y coordinate of the position to move to.
#
################################################################################

sub target ($self) {
    my ($x, $y) = $self -> position;
    my $board   = $self -> board;

    my $min;
    my $min_target;

    foreach my $leap ($self -> leaps) {
        my ($new_x, $new_y) = ($x + $$leap [0], $y + $$leap [1]);
        next unless $board -> is_valid  ($new_x, $new_y);
        next if     $self  -> been_here ($new_x, $new_y);
        my $value = $board -> to_value  ($new_x, $new_y);
        if (!defined $min || $value < $min) {
            $min        = $value;
            $min_target = [$new_x, $new_y];
        }
    }

    $min_target;
}


################################################################################
#
# nm_leaps ($self, $n, $m)
#
# Returns the positions (relative the current position) a piece can
# leap to, if it's an n/m leaper. This assumes an infinite board,
# with no fields blocked.
#
# A Knight in Western chess is a 1/2 (or 2/1) leaper.
#
#    IN:  - $self: current object
#         - $n: number of fields the piece can leap to in one direction
#         - $m: number of fields the piece can leap to in the other direction
#              ($n and $m may be identical)
#
#   OUT:  - List of leaps the piece can make.
#
# TESTS:  - t/200_Piece/100_Leaper/110_nm_leaps.t
#
################################################################################

sub nm_leaps ($self, $n, $m) {
    my   @leaps = [$n, $m];
    push @leaps => map {[ $$_ [0], -$$_ [1]]} @leaps;
    push @leaps => map {[-$$_ [0],  $$_ [1]]} @leaps;
    push @leaps => map {[ $$_ [1],  $$_ [0]]} @leaps if $n != $m;

    @leaps;
}


1;

__END__
