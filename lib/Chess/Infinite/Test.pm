package Chess::Infinite::Test;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Test::More;

use Exporter ();
our @ISA    = qw [Exporter];
our @EXPORT = qw [test_moves];


sub test_moves ($piece, $board, $name = "Available moves") {
    #
    # First, parse the field, note where a piece could land
    #
    my @offset;
    my @exp_moves;
    my $y = -1;
    foreach my $line (split /\n/ => $board) {
        $y ++;
        my $x = -1;
        foreach my $field (split ' ' => $line) {
            $x ++;
            next if $field =~ /^\.+$/;
            if ($field eq '*') {
                @offset = ($x, $y);
            }
            elsif ($field =~ /^[0-9]+$/) {
                push @exp_moves => [$x, $y, $field];
            }
            else {
                die "Failed to parse '$field'\n";
            }
        }
    }
    die "Did not find the origin\n" unless @exp_moves;

    #
    # Normalize so offset is 0
    #
    @exp_moves = map {[$$_ [0] - $offset [0],
                       $$_ [1] - $offset [1], $$_ [2]]} @exp_moves;

    #
    # Get moves from piece
    #
    my @got_moves = $piece -> rides;

    #
    # Sort them, and compare
    #
    @exp_moves = sort {$$a [0] <=> $$b [0]  ||
                       $$a [1] <=> $$b [1]  ||
                       $$a [2] <=> $$b [2]} @exp_moves; 
    @got_moves = sort {$$a [0] <=> $$b [0]  ||
                       $$a [1] <=> $$b [1]  ||
                       $$a [2] <=> $$b [2]} @got_moves; 

    is_deeply \@got_moves, \@exp_moves, $name;
}


1;
