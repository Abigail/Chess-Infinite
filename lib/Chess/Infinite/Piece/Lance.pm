package Chess::Infinite::Piece::Lance;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Lance moves an unlimited number of fields straight ahead.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_ride (0, -1, 0);
    $self;
}



1;

__END__
