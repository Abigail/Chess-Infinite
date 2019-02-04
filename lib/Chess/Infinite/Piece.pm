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
fieldhash my %values;
fieldhash my %stuck;

sub new ($class) {
    bless \do {my $var} => $class;
}

sub init ($self, %args) {
    my $board = $args {board} // die "A piece must be initialized with a board";

    #
    # Where are we moving on?
    #
    $self -> set_board ($args {board});

    $self;
}

#
# Set/return a position
#
sub set_position ($self, $x, $y, $value = undef) {
    $position  {$self}           = [$x, $y];
    $been_here {$self} {$x} {$y} = 1;
    push @{$moves  {$self}} => [$x, $y];
    push @{$values {$self}} => $value // $self -> board -> to_value ($x, $y);
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
# Set that we're stuck/Are we stuck?
#
sub set_stuck ($self) {
    $stuck {$self} = 1;
    $self;
}

sub stuck ($self) {
    $stuck {$self}
}

#
# Have we been here?
#
sub been_here ($self, $x, $y) {
    $been_here {$self} {$x} {$y};
}

#
# List of moves
#
sub moves ($self) {
    @{$moves {$self} || []};
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

#
# Run: Move the piece until it gets stuck, or until we run out
# of moves
#
sub run ($self, %args) {
    my $start     = $args {start}     //      1;
    my $max_moves = $args {max_moves} // 10_000;

    #
    # Clear the move list, and where we've been so far
    #
    $been_here {$self} = ();
    $moves {$self}     = [];
    $values {$self}    = [];
    $stuck {$self}     = 0;

    my $board = $self -> board;

    #
    # Put the piece at the start position.
    #
    my ($x, $y) = $board -> to_coordinates ($start);
    $self -> set_position ($x, $y, $start);

    my $move_count = 0;
    while ($move_count < $max_moves) {
        if (my $target = $self -> target) {
            my ($x, $y) = @$target;
            $self -> set_position ($x, $y);
            $move_count ++;
            next;
        }
        else {
            $self -> set_stuck;
            last;
        }
    }
}

1;


__END__
