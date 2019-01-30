#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Test::More;
use Chess::Infinite::Piece::Leaper::Knight;

my $knight = Chess::Infinite::Piece::Leaper::Knight:: -> new -> init;

my @got = $knight -> leaps;

my @exp = ([ 1, 2], [ 1, -2], [ 2, 1], [ 2, -1],
           [-1, 2], [-1, -2], [-2, 1], [-2, -1]);

@got = sort {$$a [0] <=> $$b [0] || $$a [1] <=> $$b [1]} @got;
@exp = sort {$$a [0] <=> $$b [0] || $$a [1] <=> $$b [1]} @exp;

is_deeply \@got, \@exp, "Expected leaps";

done_testing;

__END__
