package Chess::Infinite::Piece;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Hash::Util::FieldHash qw [fieldhash];
use List::Util            qw [min max];

fieldhash my %position;
fieldhash my %character;
fieldhash my %board;
fieldhash my %been_here;
fieldhash my %move_list;
fieldhash my %value_list;
fieldhash my %trapped;
fieldhash my %rides;
fieldhash my %heading;
fieldhash my %name;
fieldhash my %min_x;
fieldhash my %max_x;
fieldhash my %min_y;
fieldhash my %max_y;

sub new ($class) {
    bless \do {my $var} => $class;
}

sub init ($self, %args) {
    my $board = $args {board} // die "A piece must be initialized with a board";

    #
    # Where are we moving on?
    #
    $self -> set_board     ($args {board});
    $self -> set_heading   ($args {heading})   if $args {heading};
    $self -> set_name      ($args {name});
    $self -> set_Betza     ($args {Betza})     if $args {Betza};
    $self -> set_character ($args {character}) if $args {character};

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
    $min_x {$self} = $x if $x < $min_x {$self};
    $max_x {$self} = $x if $x > $max_x {$self};
    $min_y {$self} = $y if $y < $min_y {$self};
    $max_y {$self} = $y if $y > $max_y {$self};
    $self;
}
sub position ($self) {
    wantarray ? @{$position {$self}} : [@{$position {$self}}];
}

#
# Set/return the name
#
sub set_name ($self, $name) {
    $name {$self} = $name;
    $self;
}

sub name ($self) {
    $name {$self}
}

#
# Set/return character
#
sub set_character ($self, $character) {
    $character {$self} = $character;
    $self;
}

sub character ($self) {
    $character {$self};
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
# Sets the rides of an NM rider or leaper
#
sub set_nm_rides ($self, $n, $m, $max_moves = 1, %args) {
    my   @leaps = [$n, $m];
    push @leaps => map {[ $$_ [0], -$$_ [1]]} @leaps if $m;
    push @leaps => map {[-$$_ [0],  $$_ [1]]} @leaps if $n;
    push @leaps => map {[ $$_ [1],  $$_ [0]]} @leaps if $n != $m;

    #
    # Filter based on modifiers
    #
    my $modifiers = delete $args {modifiers} // "";
    if ($modifiers =~ /[fblrsv]/) {
        my @new;
        if ($modifiers =~ /f(?!h)/) {
            push @new => grep {$$_ [1] < 0 &&
                               abs ($$_ [0]) <= abs ($$_ [1])} @leaps;
        }
        if ($modifiers =~ /b(?!h)/) {
            push @new => grep {$$_ [1] > 0 &&
                               abs ($$_ [0]) <= abs ($$_ [1])} @leaps;
        }
        if ($modifiers =~ /fh/) {
            push @new => grep {$$_ [1] < 0} @leaps;
        }
        if ($modifiers =~ /bh/) {
            push @new => grep {$$_ [1] > 0} @leaps;
        }
        if ($modifiers =~ /[ls]/) {
            push @new => grep {$$_ [0] < 0 &&
                               abs ($$_ [1]) <= abs ($$_ [0])} @leaps;
        }
        if ($modifiers =~ /[rs]/) {
            push @new => grep {$$_ [0] > 0 &&
                               abs ($$_ [1]) <= abs ($$_ [0])} @leaps;
        }

        @leaps = @new;
    }

    $args {free_path} = 1 if $modifiers =~ /n/;
    
    foreach my $leap (@leaps) {
        my ($x, $y) = @$leap;
        $self -> set_ride ($x, $y, $max_moves, %args);
    }
    $self;
}


#
# Set movements of the a piece.
#
sub set_ride ($self, $dx, $dy, $max_moves = undef, %args) {
    my $heading = $self -> heading;
    if    ($heading eq 'east')  {($dx, $dy) = (-$dy,  $dx);}
    elsif ($heading eq 'south') {($dx, $dy) = (-$dx, -$dy);}
    elsif ($heading eq 'west')  {($dx, $dy) = ( $dy, -$dx);}
    push @{$rides {$self} //= []} => [$dx, $dy, $max_moves, %args];
    $self;
}

#
# Clear the rides
#
sub clear_rides ($self) {
    $rides {$self} = [];
}

#
# Return the movements
#
sub rides ($self) {
    @{$rides {$self} // []};
}

#
# Return true of the movement of the piece is colour bound.
# This is the case if all 'rides' are colour bound, which is
# the case if dx + dy is even.
#
sub is_colour_bound ($self) {
    foreach my $ride ($self -> rides) {
        return 0 if ($$ride [0] + $$ride [1]) % 2;
    }
    return 1;
}

#
# Given a direction of movement, return the position it should move to.
# Starting from the current position we move along the given direction
# ($dx, $dy) stopping if any of the following is true:
#    - we hit a position we've already been
#    - we exceed max moves (if given)
#    - the value of the position starts increasing
#
sub candidate ($self, $dx, $dy, $max_moves, %args) {
    return if     $self -> trapped;
    my $board   = $self -> board;
    my ($old_x, $old_y) = $self -> position;
    my $best_value;
    my $move_count = 0;
    my ($x, $y) = ($old_x, $old_y);
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

    #
    # Do we require a free path? That is, can we be blocked?
    # For now, we assume this only makes sense if max_moves == 1
    #
    # We're checking the "straightest" line, that is, if we leap
    # in direction (m, n) with k = max (abs (m), abs (n)), we check
    # if the position (floor (i * m / k), floor (i * n / k)) is not
    # occupied, for 0 < i < k.
    #
    if ($args {free_path}) {
        my $max_away = max abs ($dx), abs ($dy);
        foreach my $step (1 .. ($max_away - 1)) {
            my $check_x = $old_x + int ($step * $dx / $max_away);
            my $check_y = $old_y + int ($step * $dy / $max_away);
            return if $self -> been_here ($check_x, $check_y);
        }
    }

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
    my $start            = $args {start}            //      1;
    my $max_moves        = $args {max_moves}        // 10_000;
    my $max_bounding_box = $args {max_bounding_box} //    200;

    #
    # Clear the move list, and where we've been so far.
    #
    $been_here {$self}  = ();
    $move_list {$self}  = [];
    $value_list {$self} = [];
    $trapped {$self}    = 0;

    my $board = $self -> board;

    my ($x, $y) = $board -> to_coordinates ($start);

    #
    # This is the first position, so set min/max x/y
    #
    $min_x {$self} = $max_x {$self} = $x;
    $min_y {$self} = $max_y {$self} = $y;

    #
    # Put the piece at the start position.
    #
    $self -> set_position ($x, $y, $start);

    my $move_count = 0;

  MOVE:
    while (1) {
        my $target  = $self -> target;
        if (!$target) {
            $self -> set_trapped;
            last MOVE;
        }

        my ($x, $y) = @$target;
        if ($max_bounding_box) {
            my $t_min_x = min $x, $min_x {$self};
            my $t_max_x = max $x, $max_x {$self};
            my $t_min_y = min $y, $min_y {$self};
            my $t_max_y = max $y, $max_y {$self};
            last MOVE if $t_max_x - $t_min_x > $max_bounding_box ||
                         $t_max_y - $t_min_y > $max_bounding_box;
        }

        $self -> set_position ($x, $y);
        $move_count ++;
        $self -> trigger_after_move;

        last MOVE if $move_count >= $max_moves;
    }
}

#
# Return the bounding box containing the entire path
#
# Returns (min_x, min_y, max_x, max_y)
#
sub bounding_box ($self) {
    my @out = ($min_x {$self}, $min_y {$self}, $max_x {$self}, $max_y {$self});
    wantarray ? @out : \@out;
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
                        ucfirst $self -> name,
                        $trapped ? "trapped" : "arrived",
                        $$value_list [-1],
                        @{$$move_list [-1]},
                        @$move_list - 1;

    #
    # Find the bonding box
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
        my $increment = $self -> is_colour_bound ? 2 : 1;
        foreach (my $i = 1; $i < @values; $i += $increment) {
            if ($values [$i - 1] + $increment != $values [$i]) {
                $first_unused = $values [$i - 1] + $increment;
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


#
# Triggers called after various actions. (Just after move for now).
# The methods here won't do anything, but they can be overridden.
#
sub trigger_after_move ($self) {$self}

my $ATOMS = {
    W     =>  [1, 0],    # Wazir
    F     =>  [1, 1],    # Ferz
    D     =>  [2, 0],    # Dabbada
    N     =>  [2, 1],    # Knight
    A     =>  [2, 2],    # Alfil
    H     =>  [3, 0],    # Threeleaper
    C     =>  [3, 1],    # Camel
    J     =>  [3, 1],    # Camel (old notation)
    Z     =>  [3, 2],    # Zebra
    L     =>  [3, 2],    # Zebra (old notation)
    G     =>  [3, 3],    # Tripper
};

my $ALIASES = {
    R     => 'W0',       # Rook
    B     => 'F0',       # Bishop
    K     => 'WF',       # King
    Q     => 'W0F0',     # Queen
};



sub set_Betza ($self, $notation) {
    foreach my $alias (keys %$ALIASES) {
        my $replacement = $$ALIASES {$alias};
        next unless $notation =~ /(?<modifiers>[a-z]*) $alias
                                  (?<repeat>[0-9]*)/xp;
        my ($pre, $modifiers, $repeat, $post) = 
            (${^PREMATCH}, $+ {modifiers}, $+ {repeat}, ${^POSTMATCH});
        my $repl = join "" => map {$modifiers . $_ . $repeat}
                                    $replacement =~ /[A-Z][0-9]*/g;
        $notation = $pre . $repl . $post;
        redo;
    }
    while (length $notation) {
        if ($notation =~ s/^(?<modifiers>[a-z]*)
                            (?<atom>[A-Z])
                            (?<repeat>[0-9]*)//x) {
            my $modifiers = $+ {modifiers};
            my $atom      = $+ {atom};
            my $repeat    = $+ {repeat};
               $repeat    = 1 if !defined $repeat || $repeat eq '';
               $repeat    = 0 if $repeat eq $atom;
            if ($$ATOMS {$atom}) {
                my ($x, $y) = @{$$ATOMS {$atom}};
                $self -> set_nm_rides ($x, $y, $repeat,
                                        modifiers => $modifiers);
            }
            else {
                die "Failed to find atom $atom";
            }
        }
        else {
            last;
        }
    }
    die "Failed to parse $notation\n" if length $notation;
    $self;
}




1;


__END__
