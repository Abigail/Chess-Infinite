#!/opt/perl/bin/perl

use 5.026;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';

use Chess::Infinite;
use Chess::Infinite::Test;
use Test::More;

my $piece = piece "Diagonal Cube";

test_moves $piece, <<~ "--", "Available first moves";
    . . . . . . .
    . . . . . . .
    . . 0 . 0 . .
    . . . * . . .
    . . 0 . 0 . .
    . . . . . . .
    . . . . . . .
--

$piece -> trigger_after_move;

test_moves $piece, <<~ "--", "Available second moves";
    . . . . . . .
    . . . . . . .
    . . 1 . 1 . .
    . . . * . . .
    . . . 1 . . .
    . . . . . . .
    . . . . . . .
--

$piece -> trigger_after_move;

test_moves $piece, <<~ "--", "Available third moves";
    . . . . . . .
    . . . . . . .
    . . 1 . 1 . .
    . . . * . . .
    . . 1 . 1 . .
    . . . . . . .
    . . . . . . .
    . . . . . . .
--

$piece -> trigger_after_move;

test_moves $piece, <<~ "--", "Available fourth moves";
    . . . . . . .
    . . . . . . .
    . . . 1 . . .
    . . . * . . .
    . . 1 . 1 . .
    . . . . . . .
    . . . . . . .
--

$piece -> trigger_after_move;

test_moves $piece, <<~ "--", "Back to square one";
    . . . . . . .
    . . . . . . .
    . . 0 . 0 . .
    . . . * . . .
    . . 0 . 0 . .
    . . . . . . .
    . . . . . . .
--


done_testing;

__END__
