package Chess::Infinite::Piece::Champion;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Champion moves as Wazir, Alfil or Dabbaba. This piece
# comes from Omega Chess
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (1, 0, 1);   # Wazir
    $self -> set_nm_rides (2, 2, 1);   # Alfil
    $self -> set_nm_rides (2, 0, 1);   # Dabbaba
    $self;
}



1;

__END__
