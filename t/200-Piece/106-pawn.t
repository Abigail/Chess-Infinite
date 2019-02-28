#!/opt/perl/bin/perl

use 5.026;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';

use Chess::Infinite;
use Chess::Infinite::Test;
use Test::More;

my $piece = piece "Pawn";

test_moves $piece, <<~ "--", "Available first moves";
    . . . . .
    . . 2 . .
    . . * . .
    . . . . .
    . . . . .
--

$piece -> trigger_after_move;

test_moves $piece, <<~ "--", "Available subsequent moves";
    . . . . .
    . . 1 . .
    . . * . .
    . . . . .
    . . . . .
--


done_testing;

__END__
