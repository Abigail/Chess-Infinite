package Chess::Infinite::Piece::Ferz;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Ferz is a (1, 1) leaper.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_leaps (1, 1);
    $self;
}


sub name ($self) {"Ferz"}

1;

__END__
