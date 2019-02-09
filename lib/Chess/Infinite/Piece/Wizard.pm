package Chess::Infinite::Piece::Wizard;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Wizard combines the movements of the Camel and the Ferz.
# This piece comes from Omega Chess.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (3, 1, 1);   # Camel
    $self -> set_nm_rides (1, 1, 1);   # Ferz
    $self;
}



1;

__END__
