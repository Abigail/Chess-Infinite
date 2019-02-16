package Chess::Infinite::Piece::Falcon;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Falcon moves forward like a Bishop and backwards like a Rook.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_ride ( 1, -1, 0);   # Bishop
    $self -> set_ride (-1, -1, 0);   # Bishop
    $self -> set_ride ( 0,  1, 0);   # Rook
    $self;
}



1;

__END__
