package Chess::Infinite::Piece::ShogiKnight;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';

#
# The Shogi knight move 2 fields forward, and 1 field sideways.
#
sub init ($self, @args) {
    $self -> SUPER::init  (@args);
    $self -> set_ride (-1, -2, 1);
    $self -> set_ride ( 1, -2, 1);
    $self;
}


1;

__END__
