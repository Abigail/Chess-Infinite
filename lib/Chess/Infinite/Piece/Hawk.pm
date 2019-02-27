package Chess::Infinite::Piece::Hawk;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';

#
# The Hawk leaps 2 or 3 fields in any direction.
# Comes from Chess on an Infite plane
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (2, 2);
    $self -> set_nm_rides (2, 0);
    $self -> set_nm_rides (3, 3);
    $self -> set_nm_rides (3, 0);
    $self;
}



1;

__END__
