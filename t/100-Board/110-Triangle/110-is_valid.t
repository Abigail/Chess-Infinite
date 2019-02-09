#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Test::More;
use Chess::Infinite::Board::Triangle;

my $board = Chess::Infinite::Board::Triangle:: -> new -> init;

#
# Coordinates cannot be negative
#
foreach my $x (-5 .. 5) {
    foreach my $y (-5 .. 5) {
        if ($x >= 0 && $y >= 0) {
            ok  $board -> is_valid ($x, $y), "is_valid ($x, $y) is true";
        }
        else {
            ok !$board -> is_valid ($x, $y), "is_valid ($x, $y) is false";
        }
    }
}


done_testing;

__END__
