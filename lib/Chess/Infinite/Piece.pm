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
fieldhash my %move_list;
fieldhash my %value_list;
fieldhash my %trapped;
fieldhash my %rides;

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
    push @{$move_list  {$self}} => [$x, $y];
    push @{$value_list {$self}} => $value //
               $self -> board -> to_value ($x, $y);
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
# Set that we're trapped/Are we trapped?
#
sub set_trapped ($self) {
    $trapped {$self} = 1;
    $self;
}

sub trapped ($self) {
    $trapped {$self}
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
sub move_list ($self) {
    my $move_list = $move_list {$self} || [];
    wantarray ? @$move_list : $move_list;
}

#
# List of values
sub value_list ($self) {
    my $value_list = $value_list {$self} || [];
    wantarray ? @$value_list : $value_list;
}


#
# Returns the name of the piece. Must be overridden.
#
sub name ($self) {...}


#
# Set movements of the a piece.
#
sub set_ride ($self, $dx, $dy, $max_moves = undef) {
    push @{$rides {$self} //= []} => [$dx, $dy, $max_moves];
    $self;
}

#
# Return the movements
#
sub rides ($self) {
    @{$rides {$self} // []};
}


#
# Run: Move the piece until it gets trapped, or until we run out
# of moves
#
sub run ($self, %args) {
    my $start     = $args {start}     //      1;
    my $max_moves = $args {max_moves} // 10_000;

    #
    # Clear the move list, and where we've been so far
    #
    $been_here {$self}  = ();
    $move_list {$self}  = [];
    $value_list {$self} = [];
    $trapped {$self}    = 0;

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
            $self -> set_trapped;
            last;
        }
    }
}

#
# Summary: return a summary of what was done.
#
sub summary ($self) {
    my $move_list  = $self -> move_list;
    my $value_list = $self -> value_list;
    my $trapped    = $self -> trapped;
    my $summary    = "";

    $summary = sprintf "%s %s on value %d (%d, %d) after %d moves.\n" =>
                        ucfirst lc $self -> name,
                        $trapped ? "trapped" : "arrived",
                        $$value_list [-1],
                        @{$$move_list [-1]},
                        scalar @$move_list;

    #
    # Find the binding box
    #
    my $big = 0xFFFF_FFFF;
    my ($min_x, $min_y, $max_x, $max_y) = ($big, $big, -$big, -$big);
    foreach my $move (@$move_list) {
        my ($x, $y) = @$move;
        $min_x = $x if $x < $min_x;
        $min_y = $y if $y < $min_y;
        $max_x = $x if $x > $max_x;
        $max_y = $y if $y > $max_y;
    }
    $summary .= sprintf "Bounding box = %d x %d [(%d, %d) x (%d, %d)]\n" =>
                         $max_x - $min_x + 1, $max_y - $min_y + 1,
                         $min_x, $min_y, $max_x, $max_y;

    #
    # What is the maximum values, and what is the first non-visited value?
    #
    my @values = sort {$a <=> $b} @$value_list;
    my $first_unused = 0;
    #
    # Special case if the least used value != 1 (we may not have started there)
    #
    if ($values [0] != 1) {
        $first_unused = 1;
    }
    else {
        foreach (my $i = 1; $i < @values; $i ++) {
            if ($values [$i - 1] + 1 != $values [$i]) {
                $first_unused = $values [$i - 1] + 1;
                last;
            }
        }
        $first_unused ||= $values [-1] + 1;
    }
    $summary .= sprintf "Highest visited value: %d; " .
                        "lowest unvisited value: %d.\n" =>
                        $values [-1], $first_unused;


    $summary;
}


1;


__END__
