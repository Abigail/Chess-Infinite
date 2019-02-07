package Chess::Infinite::Piece::Rook;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Room moves orthogonally an unlimited number of fields.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_ride ( 1,  0);
    $self -> set_ride (-1,  0);
    $self -> set_ride ( 0,  1);
    $self -> set_ride ( 0, -1);
    $self;
}


sub name ($self) {"Rook"}

1;

__END__
