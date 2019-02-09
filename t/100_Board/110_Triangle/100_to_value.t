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

my $values = [
    [qw [  1   2   4   7  11  16  22  29]],
    [qw [  3   5   8  12  17  23  30]],
    [qw [  6   9  13  18  24  31]],
    [qw [ 10  14  19  25  32]],
    [qw [ 15  20  26  33]],
    [qw [ 21  27  34]],
    [qw [ 28  35]],
    [qw [ 36]],
];


foreach my $y (keys @$values) {
    foreach my $x (keys @{$$values [$y]}) {
        is $board -> to_value ($x, $y), $$values [$y] [$x],
                         "to_value ($x, $y)";
        my $got = $board -> to_coordinates ($$values [$y] [$x]);
        is_deeply $got, [$x, $y], "to_coordinates (" . $$values [$y] [$x] . ")";
    }
}

done_testing;

__END__
