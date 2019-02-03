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
fieldhash my %been_here;
fieldhash my %moves;

sub new ($class) {
    bless \do {my $var} => $class;
}

sub init ($self, %args) {
    my $board = $args {board} // die "A piece must be initialized with a board";
    my $start = $args {start} || 1;
    #
    # Initialize where we've been.
    #
    $been_here {$self} = ();
    $moves {$self}     = [];

    #
    # Where are we moving on?
    #
    $self -> set_board ($args {board});

    #
    # Put the piece at the start position.
    #
    my ($x, $y) = $board -> to_coordinates ($start);
    $self -> set_position ($x, $y);
    $self;
}

#
# Set/return a position
#
sub set_position ($self, $x, $y) {
    $position  {$self}           = [$x, $y];
    $been_here {$self} {$x} {$y} = 1;
    push @{$moves {$self}} => [$x, $y];
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
# Have we been here?
#
sub been_here ($self, $x, $y) {
    $been_here {$self} {$x} {$y};
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
    # Move the piece
    #
    $self -> set_position (@$target);

    1;
}


1;


__END__
