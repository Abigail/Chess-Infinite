package Chess::Infinite::Piece::Camel;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece::Leaper';

################################################################################
#
# leaps
#
# Returns the positions a Camel can leap to, relative to the current
# position. This assumes an infinite board, with no fields blocked.
#
################################################################################

sub leaps ($self) {
    return $self -> nm_leaps (3, 1);
}


sub name ($self) {"Camel"}

1;

__END__
