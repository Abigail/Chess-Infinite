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
fieldhash my %heading;

sub new ($class) {
    bless \do {my $var} => $class;
}

sub init ($self, %args) {
    my $board = $args {board} // die "A piece must be initialized with a board";

    #
    # Where are we moving on?
    #
    $self -> set_board   ($args {board});
    $self -> set_heading ($args {heading}) if $args {heading};

    $self;
}

#
# Class method, can be used for piece which have an alternative name.
#
sub alternative_names ($class) {return;}

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
# Set/return a heading
#
sub set_heading ($self, $heading) {
    $heading {$self} = $heading;
    $self;
}

sub heading ($self) {
    $heading {$self} // "";
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
# Sets the rides of an NM rider or leaper
#
sub set_nm_rides ($self, $n, $m, $max_moves = 1) {
    my   @leaps = [$n, $m];
    push @leaps => map {[ $$_ [0], -$$_ [1]]} @leaps;
    push @leaps => map {[-$$_ [0],  $$_ [1]]} @leaps;
    push @leaps => map {[ $$_ [1],  $$_ [0]]} @leaps if $n != $m;
    
    foreach my $leap (@leaps) {
        my ($x, $y) = @$leap;
        $self -> set_ride ($x, $y, $max_moves);
    }
    $self;
}


#
# Set movements of the a piece.
#
sub set_ride ($self, $dx, $dy, $max_moves = undef) {
    my $heading = $self -> heading;
    if    ($heading eq 'east')  {($dx, $dy) = (-$dy,  $dx);}
    elsif ($heading eq 'south') {($dx, $dy) = (-$dx, -$dy);}
    elsif ($heading eq 'west')  {($dx, $dy) = ( $dy, -$dx);}
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
# Given a direction of movement, return the position it should move to.
# Starting from the current position we move along the given direction
# ($dx, $dy) stopping if any of the following is true:
#    - we hit a position we've already been
#    - we exceed max moves (if given)
#    - the value of the position starts increasing
#
sub candidate ($self, $dx, $dy, $max_moves) {
    return if     $self -> trapped;
    my $board   = $self -> board;
    my ($x, $y) = $self -> position;
    my $best_value;
    my $move_count = 0;
    while (!$max_moves || $move_count ++ < $max_moves) {
        #
        # Next position to consider.
        #
        my ($new_x, $new_y) = ($x + $dx, $y + $dy);

        #
        # If we have been there, we run outside of the board, or
        # the value is higher than what we've already considered,
        # we're done.
        #
        last if     $self  -> been_here ($new_x, $new_y);
        last unless $board -> is_valid  ($new_x, $new_y);
        my $value = $board -> to_value  ($new_x, $new_y);
        last if $best_value && $value > $best_value;
        #
        # We have a potential candidate; 
        #
        ($x, $y) = ($new_x, $new_y);
        $best_value = $value;
    }
    return unless $best_value;
    return wantarray ? ($x, $y, $best_value) : [$x, $y, $best_value];
}


#
# Return the position where the piece should move to, or undef if it's trapped.
#
sub target ($self) {
    my ($best_x, $best_y, $best_value);
    foreach my $ride (@{$rides {$self}}) {
        my $candidate = $self -> candidate (@$ride) or next;
        next if $best_value && $$candidate [-1] > $best_value;
        ($best_x, $best_y, $best_value) = @$candidate;
    }
    return unless $best_value;
    return wantarray ? ($best_x, $best_y) : [$best_x, $best_y];
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
