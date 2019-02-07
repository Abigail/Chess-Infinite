package Chess::Infinite::Piece::Alfil;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Alfil is a (2, 2) leaper.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_leaps (2, 2);
    $self;
}


sub name ($self) {"Alfil"}

1;

__END__
