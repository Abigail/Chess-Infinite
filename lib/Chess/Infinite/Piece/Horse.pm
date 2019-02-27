package Chess::Infinite::Piece::Horse;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Horse moves like a Knight, but can be *blocked*.
# The Horse comes from Xiangqi.
#
sub init ($self, @args) {
    $self -> SUPER::init  (@args);
    $self -> set_nm_rides (1, 2, 1);
    $self;
}


#
# We check whether we go over a field that is blocked; if so,
# we return; else we continue with the regular check.
#
sub candidate ($self, $dx, $dy, $movement) {
    my ($free_x, $free_y) = (0, 0);
    if (abs ($dx) == 2) {
        $free_x = $dx / 2;
    }
    else {
        $free_y = $dy / 2;
    }

    my ($x, $y) = $self -> position;

    return if $self -> been_here ($x + $free_x, $y + $free_y);
    return    $self -> SUPER::candidate ($dx, $dy, $movement);
}


sub alternative_names ($class) {
    "Xiangqi Knight",
}

1;

__END__
