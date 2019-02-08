package Chess::Infinite::Piece::Archbishop;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Archbishop combines the moves of a Bishop and a Knight.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (1, 1, 0);  # Bishop
    $self -> set_nm_rides (1, 2, 1);  # Knight
    $self;
}

sub alternative_names ($class) {
    "Cardinal",
    "Knighted Bishop",
    "Princess",
    "Janus",
}

1;

__END__
