package Chess::Infinite::Piece::Hunter;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Hunter moves forward like a Rook and backwards like a Falcon.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_ride ( 0, -1, 0);   # Rook
    $self -> set_ride ( 1,  1, 0);   # Bishop
    $self -> set_ride (-1,  1, 0);   # Bishop
    $self;
}



1;

__END__
