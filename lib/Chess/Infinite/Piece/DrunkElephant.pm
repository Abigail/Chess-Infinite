package Chess::Infinite::Piece::DrunkElephant;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';

#
# The Drunk Elephant steps 1 field in any direction, except backwards.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    foreach my $x (-1 .. 1) {
        foreach my $y (-1 .. 1) {
            $self -> set_ride ($x, $y, 1) if $x || $y == -1;
        }
    }
    $self;
}



1;

__END__
