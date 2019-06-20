package Chess::Infinite::Grapher;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

our $VERSION = '2019012901';

use SVG;
use List::Util qw [min max];
use Colour::Name;

my $SCALE         =  10;   # Pixels
my $MARGIN_LEFT   =   1;   # "scales".
my $MARGIN_RIGHT  =   1;
my $MARGIN_TOP    =   1;
my $MARGIN_BOTTOM =   1;

my $COLOURS       = [qw [Red Blue Green Goldenrod]];
my $STEPS         =  64;

my $extension     = "svg";

my sub file_name ($piece, $type) {
    my $name = lc $piece -> name;
    $name =~ s/\s+/_/g;

    $name . "-" . $type . "." . $extension;
}


my sub draw_unvisited (%args) {
    my $svg         = $args {svg};
    my $piece       = $args {piece};
    my $scale       = $args {scale};
    my $min_x       = $args {min_x};
    my $min_y       = $args {min_y};
    my $max_x       = $args {max_x};
    my $max_y       = $args {max_y};
    my $margin_top  = $args {margin_top};
    my $margin_left = $args {margin_left};

    my @move_list = $piece -> move_list;

    #
    # Mark which point have been visited.
    #
    my %visited;
    foreach my $move (@move_list) {
        $visited {$$move [0]} {$$move [1]} = 1;
    }
    #
    # And draw a circle there
    #
    foreach my $y ($min_y .. $max_y) {
        foreach my $x ($min_x .. $max_x) {
            next if $visited {$x} {$y};
            my $CX = ($x - $min_x) * $scale + $margin_left;
            my $CY = ($y - $min_y) * $scale + $margin_top;
            $svg -> circle (
                cx    => $CX,
                cy    => $CY,
                r     => $scale / 8,
                class => "unvisited",
            );
        }
    }
}

#
# Draws part of a path, doing a blend between two colours; we'll start
# with the from_colour, and end *one step* away from the end_colour
# (that way, a next sub path can start with that colour), unless the
# "is_last" flag was set.
#
my sub draw_sub_path (%args) {
    my $from_colour   = rgb $args {from_colour}, $RGB_TRIPLET;
    my $to_colour     = rgb $args {to_colour},   $RGB_TRIPLET;
    my $steps         = $args {steps};
    my $X             = $args {X};
    my $Y             = $args {Y};
    my $is_last       = $args {is_last};
    my $svg           = $args {svg};
    my $scale         = $args {scale};
    my $show_path     = $args {show_path};
    my $show_visited  = $args {show_visited};

    state $path_count = 0;

    #
    # Blends is the number of times we 'blend' from one colour to the
    # other; it's usually the same as 'steps', so we're left with one
    # step away from the target colour. But if we're the sub path, we
    # want to finish on the target colour. Adjusting 'blends' just gets
    # us there.
    #
    my $blends = $steps;
       $blends -- if $is_last && $blends > 1;
    foreach my $step (0 .. $steps - 1) {
        my $from = int (.5 + ($step + 0) * $#$X / $steps);
        my $to   = int (.5 + ($step + 1) * $#$X / $steps);
        my @rgb  = map {
                   int (.5 + ($blends - $step) * $$from_colour [$_] / $blends +
                                        $step  * $$to_colour   [$_] / $blends)}
                   keys @$from_colour;

        #
        # Draw the section of the path with the right colour
        #
        my $points = $svg -> get_path (
            x    =>  [@$X [$from .. $to]],
            y    =>  [@$Y [$from .. $to]],
           -type => 'path',
        );

        my $colour = do {local $" = ","; "rgb(@rgb)"};

        if ($show_path) {
            $svg -> path (
                %$points,
                id    =>  "path-" . ++ $path_count,
                class =>  "path",
                style => {
                    'stroke'       => $colour,
                },
            );
        }

        if ($show_visited) {
            foreach my $index ($from + 1 .. $to) {
                $svg -> circle (
                    cx     =>  $$X [$index],
                    cy     =>  $$Y [$index],
                    r      =>  $scale / 8,
                    style  => {
                        fill => $colour,
                    }
                )
            }
        }
    }
}



my sub draw_terminals (%args) {
    my $X     = $args {X};
    my $Y     = $args {Y};
    my $scale = $args {scale};
    my $svg   = $args {svg};

    foreach my $index (0, -1) {
        $svg -> circle (
            cx     =>  $$X [$index],
            cy     =>  $$Y [$index],
            r      =>  $scale / 4,
            class  =>  "terminal",
        )
    }
}


my sub draw_path (%args) {
    my $colours      = $args {colours};
    my $svg          = $args {svg};
    my @X            = @{$args {X}};
    my @Y            = @{$args {Y}};
    my $steps        = $args {steps};
    my $scale        = $args {scale};
    my $show_path    = $args {show_path};
    my $show_visited = $args {show_visited};

    my $colour_steps = @$colours - 1;
    foreach my $colour_step (0 .. ($colour_steps - 1)) {
        my $from_colour = $$colours [$colour_step];
        my $to_colour   = $$colours [$colour_step + 1];

        #
        # Calculate how many steps we have to take for this blend
        #
        my $steps = int (.5 + ($colour_step + 1) * $steps / $colour_steps) -
                    int (.5 + ($colour_step + 0) * $steps / $colour_steps);

        my $from  = int (.5 + ($colour_step + 0) * @X / $colour_steps);
        my $to    = int (.5 + ($colour_step + 1) * @X / $colour_steps);

        #
        # Mark the last sub path; we also need one point less.
        #
        my $is_last = $colour_step == $colour_steps - 1;
        $to -- if $is_last;

        draw_sub_path from_colour  => $from_colour,
                      to_colour    => $to_colour,
                      steps        => $steps,
                      X            => [@X [$from .. $to]],
                      Y            => [@Y [$from .. $to]],
                      svg          => $svg,
                      is_last      => $is_last,
                      scale        => $scale,
                      show_path    => $show_path,
                      show_visited => $show_visited,
        ;
    }
}


my sub set_styles (%args) {
    my $svg = $args {svg};

    my $style = $svg -> style;
    $style -> CDATA (<<~ '--');
        circle.terminal  {fill:          black;}
        circle.unvisited {fill:          rgb(200,200,200);
                          opacity:      .5,}
        path.path        {fill-opacity:  0;
                          opacity:      .5;}
    --
}

sub route ($class, %args) {
    my $piece         =  $args {piece};
    my $scale         =  $args {scale}         // $SCALE;
    my $margin_top    = ($args {margin_top}    // $MARGIN_TOP)    * $scale;
    my $margin_left   = ($args {margin_left}   // $MARGIN_LEFT)   * $scale;
    my $margin_bottom = ($args {margin_bottom} // $MARGIN_BOTTOM) * $scale;
    my $margin_right  = ($args {margin_right}  // $MARGIN_RIGHT)  * $scale;

    my @moves = $piece -> move_list;
    my @X = map {$$_ [0]} @moves;
    my @Y = map {$$_ [1]} @moves;

    #
    # Find the minimum x/y values.
    #
    my $min_x = min @X;
    my $max_x = max @X;
    my $min_y = min @Y;
    my $max_y = max @Y;
    
    #
    # Move points so the minimum is 0.
    #
    @X = map {$_ - $min_x} @X;
    @Y = map {$_ - $min_y} @Y;

    #
    # Scale the points, and shift them.
    #
    @X = map {$_ * $scale + $margin_left} @X;
    @Y = map {$_ * $scale + $margin_top}  @Y;

    #
    # Create the SVG image
    #
    my $svg = SVG:: -> new (
        width  => max (@X) + $margin_right,
        height => max (@Y) + $margin_bottom,
    );

    draw_unvisited svg          =>  $svg,
                   piece        =>  $piece,
                   scale        =>  $scale,
                   min_x        =>  $min_x,
                   max_x        =>  $max_x,
                   min_y        =>  $min_y,
                   max_y        =>  $max_y,
                   margin_left  =>  $margin_left,
                   margin_top   =>  $margin_top, if $args {show_unvisited};


    draw_path  colours      => $args {colours} ? [split /,/ => $args {colours}]
                                               : $COLOURS,
               svg          => $svg,
               X            => \@X,
               Y            => \@Y,
               steps        => $args {steps} || $STEPS,
               scale        => $scale,
               show_path    => $args {show_path},
               show_visited => $args {show_visited},
           if $args {show_path} || $args {show_visited};

    #
    # Draw start/end circles
    #
    draw_terminals X     => \@X,
                   Y     => \@Y,
                   svg   => $svg,
                   scale => $scale if $args {show_terminals};


    set_styles svg => $svg;

    return $svg if $args {svg};

    my $xml = $svg -> xmlify;

    my $file = file_name $piece, "path";
    open my $fh, ">", $file or die "Failed to open $file: $!";
    print $fh $xml;
    close $fh or die "Failed to close $file: $!";
}

1;

__END__
