package Chess::Infinite::Piece::Threeleaper;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Threeleaper moves orthogonally a double step
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (3,  0);
    $self;
}


sub name ($self) {"Threeleaper"}

1;

__END__
