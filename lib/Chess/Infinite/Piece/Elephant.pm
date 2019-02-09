package Chess::Infinite::Piece::Elephant;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Elephant jumps 2 fields diagonally, but cannot have an
# intervening piece. This piece comes from Xiangqi.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (2, 2);
    $self;
}


#
# We check whether we go over a field that is blocked; if so,
# we return; else we continue with the regular check.
#
sub candidate ($self, $dx, $dy, $movement) {
    my ($x, $y) = $self -> position;
    return if $self -> been_here ($x + $dx / 2, $y + $dy / 2);
    return    $self -> SUPER::candidate ($dx, $dy, $movement);
}


sub alternative_names ($self) {
    "Xiangqi Bishop",
}

1;

__END__
