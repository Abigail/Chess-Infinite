package Chess::Infinite::Piece::DiagonalCube;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';
use Hash::Util::FieldHash qw [fieldhash];

#
# The orthogonal cube *changes* how it moves after each move.
# It cycles between Rook, Chariot, Swallow's Wing and Go-Between
#

my $BISHOP          = 0;
my $TILE_GENERAL    = $BISHOP       + 1;
my $CAT_SWORD       = $TILE_GENERAL + 1;
my $DOG             = $CAT_SWORD    + 1;
my $NUMBER_OF_TYPES = $DOG          + 1;

fieldhash my %current_move;

#
# The Shogi knight move 2 fields forward, and 1 field sideways.
#
sub init ($self, @args) {
    $self -> SUPER::init  (@args);
    $current_move {$self} = $BISHOP;
    $self -> set_movements;
    $self;
}


sub inc_move ($self) {
    $current_move {$self} ++;
    $current_move {$self} %= $NUMBER_OF_TYPES;
    $self;
}


sub current_move ($self) {
    $current_move {$self};
}


sub set_movements ($self) {
    my $current_move = $self -> current_move;

    $self -> clear_rides;

    if ($current_move == $BISHOP) {
        $self -> set_nm_rides (1, 1, 0);
    }
    elsif ($current_move == $TILE_GENERAL) {
        $self -> set_ride ( 1, -1, 1);
        $self -> set_ride (-1, -1, 1);
        $self -> set_ride ( 0,  1, 1);
    }
    elsif ($current_move == $CAT_SWORD) {
        $self -> set_nm_rides (1, 1, 1);
    }
    elsif ($current_move == $DOG) {
        $self -> set_ride ( 1,  1, 1);
        $self -> set_ride (-1,  1, 1);
        $self -> set_ride ( 0, -1, 1);
    }
    else {
        die "Unexpected current move '$current_move'";
    }
    $self;
}

sub trigger_after_move ($self) {
    $self -> inc_move;
    $self -> set_movements;
}

1;

__END__
