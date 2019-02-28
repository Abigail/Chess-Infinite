#!/opt/perl/bin/perl

use 5.026;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';

use Chess::Infinite;
use Chess::Infinite::Test;
use Test::More;

my $piece = piece "Charging Rook";

test_moves $piece, <<~ "--";
    . . . . . . .
    . . . . . . .
    . . . 0 . . .
    . . 0 * 0 . .
    . . 1 1 1 . .
    . . . . . . .
    . . . . . . .
--


done_testing;

__END__
