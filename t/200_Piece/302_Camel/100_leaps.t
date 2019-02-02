#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Test::More;

use Chess::Infinite::Piece::Camel;
use Chess::Infinite::Board::Spiral;

my $board = Chess::Infinite::Board::Spiral:: -> new -> init;
my $camel = Chess::Infinite::Piece::Camel::  -> new -> init (board => $board);

my @got = $camel -> leaps;

my @exp = ([ 1, 3], [ 1, -3], [ 3, 1], [ 3, -1],
           [-1, 3], [-1, -3], [-3, 1], [-3, -1]);

@got = sort {$$a [0] <=> $$b [0] || $$a [1] <=> $$b [1]} @got;
@exp = sort {$$a [0] <=> $$b [0] || $$a [1] <=> $$b [1]} @exp;

is_deeply \@got, \@exp, "Expected leaps";

done_testing;

__END__
