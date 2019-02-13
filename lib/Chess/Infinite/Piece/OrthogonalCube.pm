package Chess::Infinite::Piece::OrthogonalCube;

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

my $ROOK            = 0;
my $CHARIOT         = $ROOK         + 1;
my $SWALLOW_WING    = $CHARIOT      + 1;
my $GO_BETWEEN      = $SWALLOW_WING + 1;
my $NUMBER_OF_TYPES = $GO_BETWEEN   + 1;

fieldhash my %current_move;

#
# The Shogi knight move 2 fields forward, and 1 field sideways.
#
sub init ($self, @args) {
    $self -> SUPER::init  (@args);
    $current_move {$self} = $ROOK;
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

    if ($current_move == $ROOK) {
        $self -> set_nm_rides (1, 0, 1);
    }
    elsif ($current_move == $CHARIOT) {
        $self -> set_ride (0,  1, 0);
        $self -> set_ride (0, -1, 0);
    }
    elsif ($current_move == $SWALLOW_WING) {
        $self -> set_ride ( 1, 0, 1);
        $self -> set_ride (-1, 0, 1);
    }
    elsif ($current_move == $GO_BETWEEN) {
        $self -> set_ride (0,  1, 1);
        $self -> set_ride (0, -1, 1);
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
