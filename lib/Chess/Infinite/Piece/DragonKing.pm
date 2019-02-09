package Chess::Infinite::Piece::DragonKing;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Dragon King moves orthogonally an unlimited number of fields,
# or one step diagonally.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (1, 0, 0);
    $self -> set_nm_rides (1, 1, 1);
    $self;
}

sub alternative_names ($class) {
    "Promoted Rook"
}


1;

__END__
