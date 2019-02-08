package Chess::Infinite::Piece::SilverGeneral;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';

#
# The Silver General moves 1 field in diagonally, or straight ahead.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (1, 1);
    $self -> set_ride (0, -1, 1);
    $self;
}

sub name ($self) {"Silver General"}

1;

__END__
