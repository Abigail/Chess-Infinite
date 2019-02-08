package Chess::Infinite::Piece::GoldGeneral;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';

#
# The Gold General steps 1 field in any direction, except diagonally backwards.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    foreach my $x (-1 .. 1) {
        foreach my $y (-1 .. 1) {
            $self -> set_ride ($x, $y, 1)
                            if $y == -1        ||
                               $y ==  0 &&  $x ||
                               $y ==  1 && !$x;
        }
    }
    $self;
}

sub alternative_names ($class) {
    "Golden General";
}

sub name ($self) {"Gold General"}

1;

__END__
