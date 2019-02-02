package Chess::Infinite::Piece::DrunkenElephant;

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
# Returns the positions a Drunken Elephant can leap to, relative to the current
# position. This assumes an infinite board, with no fields blocked.
#
################################################################################

sub leaps ($self) {
    my @leaps;
    foreach my $x (-1 .. 1) {
        foreach my $y (-1 .. 1) {
            push @leaps => [$x, $y] if $x || $y == -1;
        }
    }

    @leaps;
}


sub name ($self) {"Drunken Elephant"}

1;

__END__
