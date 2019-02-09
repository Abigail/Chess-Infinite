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
    $self -> set_nm_rides (1, 0, 0);
    $self;
}


sub alternative_names ($self) {
    "Chariot",          # Xiangqi
}


1;

__END__
