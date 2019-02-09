package Chess::Infinite::Piece::DragonHorse;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';


#
# The Dragon Horse moves diagonally an unlimited number of fields,
# or one step orthogonal.
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (1, 1, 0);
    $self -> set_nm_rides (1, 0, 1);
    $self;
}

sub alternative_names ($self) {
    "Promoted Bishop";
}

1;

__END__
