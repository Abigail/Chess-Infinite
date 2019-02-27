package Chess::Infinite::Piece::JanggiElephant;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Janggi Elephant moves on step orthogonally, and then
# two pieces diagonally, but can be *blocked*.
#
sub init ($self, @args) {
    $self -> SUPER::init  (@args);
    $self -> set_nm_rides (2, 3, 1);
    $self;
}


#
# We check whether we go over a field that is blocked; if so,
# we return; else we continue with the regular check.
#
sub candidate ($self, $dx, $dy, $movement) {
    my @to_check;

    if (abs ($dx) == 3) {
        push @to_check => [$dx / 3, 0], [2 * $dx / 3, $dy / 2];
    }
    else {
        push @to_check => [0, $dy / 3], [$dx / 2, 2 * $dy / 3];
    }

    my ($x, $y) = $self -> position;

    foreach my $to_check (@to_check) {
        my ($check_dx, $check_dy) = @$to_check;
        return if $self -> been_here ($x + $check_dx, $y + $check_dy);
    }
    return $self -> SUPER::candidate ($dx, $dy, $movement);
}


1;

__END__
