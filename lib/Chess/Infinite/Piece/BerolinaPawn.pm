package Chess::Infinite::Piece::BerolinaPawn;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';

use Hash::Util::FieldHash qw [fieldhash];

fieldhash my %moved;

#
# The Berolina Pawn may move up to two steps diagonally forward
# on the first move, and one afterwards.
#
sub init ($self, @args) {
    $self -> SUPER::init  (@args);
    $self -> set_ride ( 1, -1, 2);
    $self -> set_ride (-1, -1, 2);
    $self;
}



#
# After the first move, we can only move 1
#
sub trigger_after_move ($self) {
    return if $moved {$self};
    $self -> clear_rides;
    $self -> set_ride ( 1, -1, 1);
    $self -> set_ride (-1, -1, 1);
}


1;

__END__
