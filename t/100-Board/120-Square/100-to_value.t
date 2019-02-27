#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Test::More;
use Chess::Infinite::Board::Square;

my $board = Chess::Infinite::Board::Square:: -> new -> init;

my $values = [
    [qw [  1   2   5  10  17  26  37  50]],
    [qw [  4   3   6  11  18  27  38  51]],
    [qw [  9   8   7  12  19  28  39  52]],
    [qw [ 16  15  14  13  20  29  40  53]],
    [qw [ 25  24  23  22  21  30  41  54]],
    [qw [ 36  35  34  33  32  31  42  55]],
    [qw [ 49  48  47  46  45  44  43  56]],
    [qw [ 64  63  62  61  60  59  58  57]],
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
