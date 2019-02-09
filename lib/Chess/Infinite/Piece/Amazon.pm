package Chess::Infinite::Piece::Amazon;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Amazon combines the moves of the Queen and Knight. Or the
# Rook, Bishop and Knight.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (1, 1, 0);  # Bishop
    $self -> set_nm_rides (1, 0, 0);  # Rook
    $self -> set_nm_rides (1, 2, 1);  # Knight
    $self;
}

sub alternative_names ($class) {
    "Maharadja",
}


1;

__END__
