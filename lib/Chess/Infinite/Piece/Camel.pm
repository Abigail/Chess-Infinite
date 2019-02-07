package Chess::Infinite::Piece::Camel;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Camel is a (3, 1) leaper.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (3, 1);
    $self;
}


sub name ($self) {"Camel"}

1;

__END__
