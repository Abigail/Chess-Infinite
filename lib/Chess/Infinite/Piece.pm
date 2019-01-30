package Chess::Infinite::Piece;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Hash::Util::FieldHash qw [fieldhash];

fieldhash my %position;
fieldhash my %board;

sub new ($class) {
    bless \do {my $var} => $class;
}

sub init ($self) {
    $self -> set_position (0, 0);
    $self
}

#
# Set/return a position
#
sub set_position ($self, $x, $y) {
    $position {$self} = [$x, $y];
    $self;
}
sub position ($self) {
    wantarray ? @{$position {$self}} : [@{$position {$self}}];
}


#
# Set/return a board
#
sub set_board ($self, $board) {
    $board {$self} = $board;
    $self
}
sub board ($self) {
    $board {$self};
}


#
# Returns the name of the piece. Must be overridden.
#
sub name ($self) {...}

#
# Move the piece, if possible. Returns true if the piece could be moved,
# false otherwise.
#
sub move ($self) {
    my $target = $self -> target or return;

    #
    # Block the current position
    #
    $self -> board -> block ($self -> position);

    #
    # Move the piece
    #
    $self -> set_position   (@$target);

    1;
}


1;


__END__
