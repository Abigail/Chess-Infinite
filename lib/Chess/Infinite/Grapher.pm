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

my @COLOURS       = qw [Red Blue Green Yellow];
my $STEPS         =  64;

my $extension     = "svg";

my sub file_name ($piece, $type) {
    my $name = lc $piece -> name;
    $name =~ s/\s+/_/g;

    $name . "-" . $type . "." . $extension;
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

    my $colour_steps = @COLOURS - 1;
    say "colour_steps = $colour_steps; STEPS = $STEPS";
    foreach my $step (0 .. ($colour_steps - 1)) {
        my $from_colour = $COLOURS [$step];
        my $to_colour   = $COLOURS [$step + 1];

        my $from = int (.5 + ($step + 0) * $STEPS / $colour_steps);
        my $to   = int (.5 + ($step + 1) * $STEPS / $colour_steps);

        say "$from_colour <-> $to_colour;  $from <-> $to";

        foreach my $inner_step ($from .. ($to - 1)) {
            say "  inner_step: $inner_step";
        }
    }

 #  foreach my $step (0 .. $STEPS - 1) {
 #      my $from            = int (.5 + ($step + 0) * @X / $STEPS);
 #      my $to              = int (.5 + ($step + 1) * @X / $STEPS);
 #      my $from_colour_idx = int ($step * (@COLOURS - 1) / $STEPS);
 #      my $to_colour_idx   = $from_colour_idx + 1;
 #      my $from_colour     = $COLOURS [$from_colour_idx] // "??";
 #      my $to_colour       = $COLOURS [$to_colour_idx] // "??";
 #      say "$from ... $to; $from_colour/$from_colour_idx <-> $to_colour";
 #  }

    #
    # Draw the path
    #
    my $points = $svg -> get_path (
        x    =>  \@X,
        y    =>  \@Y,
       -type => 'path',
    );

    $svg -> path (
        %$points,
        id    =>  'path',
        style => {
            'fill-opacity' => 0,
            'stroke'       => 'red',
        },
    );

    my $xml = $svg -> xmlify;

    my $file = file_name $piece, "path";
    open my $fh, ">", $file or die "Failed to open $file: $!";
    print $fh $xml;
    close $fh or die "Failed to close $file: $!";
}

1;

__END__
