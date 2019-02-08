package Chess::Infinite::Piece::Queen;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Queen moves diagonally and orthogonally an unlimited number of fields.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides ( 1, 1, 0);
    $self -> set_nm_rides ( 1, 0, 0);
    $self;
}



1;

__END__
