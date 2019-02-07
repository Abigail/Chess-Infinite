package Chess::Infinite::Piece::King;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';

#
# The King is a combined (1, 1) and a (1, 0) leaper.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (1, 1);
    $self -> set_nm_rides (1, 0);
    $self;
}


sub name ($self) {"King"}

1;

__END__
