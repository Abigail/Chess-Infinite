#!/opt/perl/bin/perl

use 5.026;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';

use Chess::Infinite;
use Chess::Infinite::Test;
use Test::More;

my $piece = piece "Short Rook";

test_moves $piece, <<~ "--";
    . . . . . . .
    . . . . . . .
    . . . 4 . . .
    . . 4 * 4 . .
    . . . 4 . . .
    . . . . . . .
    . . . . . . .
--


done_testing;

__END__
