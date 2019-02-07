package Chess::Infinite::Piece::Bishop;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Bishops moves diagonally an unlimited number of fields.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_ride ( 1,  1);
    $self -> set_ride ( 1, -1);
    $self -> set_ride (-1,  1);
    $self -> set_ride (-1, -1);
    $self;
}


sub name ($self) {"Bishop"}

1;

__END__
