package Chess::Infinite::Piece::Monk;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Monk moves as either a Bishop, or a King. Name comes from Chakra.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (1, 1, 0);  # Bishop
    $self -> set_nm_rides (1, 0, 1);  # King
    $self;
}


1;

__END__
