package Chess::Infinite::Piece::Knight;

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
# Returns the positions a Knight can leap to, relative to the current
# position. This assumes an infinite board, with no fields blocked.
#
################################################################################

sub leaps ($self) {
    return $self -> nm_leaps (1, 2);
    my   @leaps = [1, 2];
    push @leaps => map {[ $$_ [0], -$$_ [1]]} @leaps;
    push @leaps => map {[-$$_ [0],  $$_ [1]]} @leaps;
    push @leaps => map {[ $$_ [1],  $$_ [0]]} @leaps;

    @leaps;
}


sub name ($self) {"Knight"}

1;

__END__
