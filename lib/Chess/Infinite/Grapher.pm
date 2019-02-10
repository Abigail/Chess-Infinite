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

my $SIZE          = 750;
my $LEFT_MARGIN   =  10;
my $RIGHT_MARGIN  =  10;
my $TOP_MARGIN    =  10;
my $BOTTOM_MARGIN =  10;
my $MIN_SCALE     =  10;

my $COLOURS       = [qw [Red Blue Green Goldenrod]];
my $STEPS         =  64;

my $extension     = "svg";

my sub file_name ($piece, $type) {
    my $name = lc $piece -> name;
    $name =~ s/\s+/_/g;

    $name . "-" . $type . "." . $extension;
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

        $svg -> path (
            %$points,
            id    =>  "path-" . ++ $path_count,
            style => {
                'fill-opacity' => 0,
                'stroke'       => $colour,
                'opacity'      => .5,
            },
        );

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



my sub draw_path (%args) {
    my $colours = $args {colours};
    my $svg     = $args {svg};
    my @X       = @{$args {X}};
    my @Y       = @{$args {Y}};
    my $steps   = $args {steps};
    my $scale   = $args {scale};

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

        draw_sub_path from_colour => $from_colour,
                      to_colour   => $to_colour,
                      steps       => $steps,
                      X           => [@X [$from .. $to]],
                      Y           => [@Y [$from .. $to]],
                      svg         => $svg,
                      is_last     => $is_last,
                      scale       => $scale,
        ;
    }
}

sub route ($class, %args) {
    my $piece     = $args {piece};
    my $min_scale = $args {min_scale} // $MIN_SCALE;

    my @moves = $piece -> move_list;
    my @X = map {$$_ [0]} @moves;
    my @Y = map {$$_ [1]} @moves;

    #
    # Find the minimum x/y values. Move points so the minimum is 0.
    #
    my $min_x = min @X; @X = map {$_ - $min_x} @X;
    my $min_y = min @Y; @Y = map {$_ - $min_y} @Y;

    #
    # Find the maximum x/y values.
    #
    my $max_x = max @X;
    my $max_y = max @Y;

    #
    # And the max of that.
    #
    my $max = max $max_x, $max_y;

    #
    # Calculate the scale.
    #
    my $scale = $SIZE / $max;
       $scale = $min_scale if $min_scale && $scale < $min_scale;

    #
    # Scale the points, and shift them.
    #
    @X = map {$_ * $scale + $LEFT_MARGIN} @X;
    @Y = map {$_ * $scale + $TOP_MARGIN}  @Y;

    #
    # Create the SVG image
    #
    my $svg = SVG:: -> new (
        width  => max (@X) + $RIGHT_MARGIN,
        height => max (@Y) + $BOTTOM_MARGIN,
    );

    draw_path  colours => $args {colours} ? [split /,/ => $args {colours}]
                                          : $COLOURS,
               svg     => $svg,
               X       => \@X,
               Y       => \@Y,
               steps   => $args {steps} || $STEPS,
               scale   => $scale,
    ;

    #
    # Draw start/end circles
    #
    foreach my $index (0, -1) {
        $svg -> circle (
            cx     =>  $X [$index],
            cy     =>  $Y [$index],
            r      =>  $scale / 4,
            style  => {
                fill => 'black',
            }
        )
    }

    my $xml = $svg -> xmlify;

    my $file = file_name $piece, "path";
    open my $fh, ">", $file or die "Failed to open $file: $!";
    print $fh $xml;
    close $fh or die "Failed to close $file: $!";
}

1;

__END__
