package Chess::Infinite::Piece::Knight;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use parent 'Chess::Infinite::Piece';

#
# The Knight is a (1, 2) leaper
#
sub init ($self, @args) {
    $self -> SUPER::init  (@args);
    $self -> set_nm_rides (1, 2);
    $self;
}

#
# Class method
#
sub alternative_names ($class) {qw [N]}

sub name ($self) {"Knight"}

1;

__END__
