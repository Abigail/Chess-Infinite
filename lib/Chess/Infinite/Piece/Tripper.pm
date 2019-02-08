package Chess::Infinite::Piece::Tripper;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Tripper is a (3, 3) leaper.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (3, 3);
    $self;
}


sub name ($self) {"Tripper"}

1;

__END__
