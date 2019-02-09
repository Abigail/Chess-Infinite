package Chess::Infinite::Piece::Samurai;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';

#
# The Samurai moves as a King or a Knight. The name comes from Chakra chess
#
sub init ($self, @args) {
    $self -> SUPER::init (@args);
    $self -> set_nm_rides (1, 1, 1);   # King
    $self -> set_nm_rides (1, 0, 1);   # King
    $self -> set_nm_rides (2, 1, 1);   # Knight
    $self;
}

sub additional_names ($class) {
    "Knighted King",
    "Crowned Knight",
}


1;

__END__
