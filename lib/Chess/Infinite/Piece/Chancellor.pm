package Chess::Infinite::Piece::Chancellor;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Chancellor combines the moves of a Rook and a Knight.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (1, 0, 0);  # Rook
    $self -> set_nm_rides (1, 2, 1);  # Knight
    $self;
}

sub alternative_names ($class) {
    "Marshall",
    "Empress",
    "Knighted Rook",
}

1;

__END__
