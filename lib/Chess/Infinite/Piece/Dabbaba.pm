package Chess::Infinite::Piece::Dabbaba;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Dabbaba moves orthogonally a double step
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (2,  0);
    $self;
}


sub name ($self) {"Dabbaba"}

1;

__END__
