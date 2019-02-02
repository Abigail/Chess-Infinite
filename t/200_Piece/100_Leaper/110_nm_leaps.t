#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Test::More;
use Chess::Infinite::Piece::Leaper;
use Chess::Infinite::Board::Spiral;

my $board  = Chess::Infinite::Board::Spiral:: -> new -> init;
my $leaper = Chess::Infinite::Piece::Leaper:: -> new -> init (board => $board);

sub as_leap {
    $$a [0] <=> $$b [0] || $$a [1] <=> $$b [1]
}

sub run_test ($name, $n, $m) {
    my   @exp =  ([$n, $m], [$n, -$m], [-$n, $m], [-$n, -$m]);
    push @exp => ([$m, $n], [$m, -$n], [-$m, $n], [-$m, -$n])
          unless $n == $m;

    my @got = $leaper -> nm_leaps ($n, $m);

    @got = sort as_leap @got;
    @exp = sort as_leap @exp;

    is_deeply \@got, \@exp, $name
}

run_test "1/1 leaper", 1, 1;
run_test "3/2 leaper", 3, 2;
run_test "4/3 leaper", 4, 3;

done_testing;


__END__
