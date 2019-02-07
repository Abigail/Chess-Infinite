package Chess::Infinite::Piece::Zebra;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Zebra is a (3, 2) leaper.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_leaps (3, 2);
    $self;
}


sub name ($self) {"Zebra"}

1;

__END__
