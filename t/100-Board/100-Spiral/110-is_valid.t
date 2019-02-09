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

#
# Trivial test, as all integers are valid
#

foreach my $x (-5 .. 5) {
    foreach my $y (-5 .. 5) {
        ok $board -> is_valid ($x, $y), "is_valid ($x, $y) is true";
    }
}

done_testing;

__END__
