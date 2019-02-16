package Chess::Infinite::Piece::KnightRider;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';

#
# The KnightRider is a (1, 2) long leaper
#
sub init ($self, @args) {
    $self -> SUPER::init  (@args);
    $self -> set_nm_rides (1, 2, 0);
    $self;
}


1;

__END__
