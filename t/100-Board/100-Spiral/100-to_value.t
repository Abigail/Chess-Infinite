#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Test::More;
use Chess::Infinite::Board::Spiral;

my $board = Chess::Infinite::Board::Spiral:: -> new -> init;

my $values = [
    [qw [ 37  36  35  34  33  32  31]],
    [qw [ 38  17  16  15  14  13  30]],
    [qw [ 39  18   5   4   3  12  29]],
    [qw [ 40  19   6   1   2  11  28]],
    [qw [ 41  20   7   8   9  10  27]],
    [qw [ 42  21  22  23  24  25  26]],
    [qw [ 43  44  45  46  47  48  49]],
];

my $offset = int (@$values / 2);


foreach my $i (keys @$values) {
    my $y = $i - $offset;
    foreach my $j (keys @{$$values [$i]}) {
        my $x = $j - $offset;
        is $board -> to_value ($x, $y), $$values [$i] [$j],
                         "to_value ($x, $y)";
        my $got = $board -> to_coordinates ($$values [$i] [$j]);
        is_deeply $got, [$x, $y], "to_coordinates (" . $$values [$i] [$j] . ")";
    }
}

done_testing;

__END__
