package Chess::Infinite::Piece::Knight;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Chess::Infinite::Piece;
our @ISA = qw [Chess::Infinite::Piece];


sub min_move ($self) {
    my ($x, $y) = $self -> position;
    my $board   = $self -> board;

    my $min;
    my $min_move;

    foreach my $jump ([1, 2], [1, -2], [-1, 2], [-1, -2],
                      [2, 1], [2, -1], [-2, 1], [-2, -1]) {
        my ($new_x, $new_y) = ($x + $$jump [0], $y + $$jump [1]);
        next unless $board -> is_valid   ($x, $y);
        next if     $board -> is_blocked ($x, $y);
        my $value = $board -> to_integer ($x, $y);
        if (defined $min && $value < $min) {
            $min      = $value;
            $min_move = [$new_x, $new_y];
        }
    }

    $min_move;
}


1;

__END__
