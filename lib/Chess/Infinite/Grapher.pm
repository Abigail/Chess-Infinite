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

my $SIZE        = 750;
my $LEFT_MARGIN =  10;
my $TOP_MARGIN  =  10;

sub route ($class, %args) {
    my $piece = $args {piece};

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

    #
    # Scale the points, and shift them.
    #
    @X = map {$_ * $scale + $LEFT_MARGIN} @X;
    @Y = map {$_ * $scale + $TOP_MARGIN}  @Y;

    #
    # Create the SVG image
    #
    my $svg = SVG:: -> new (
        width  => $SIZE + $LEFT_MARGIN,
        height => $SIZE + $TOP_MARGIN,
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

    my $file = $piece -> name . "-path.svg";
    open my $fh, ">", $file or die "Failed to open $file: $!";
    print $fh $xml;
    close $fh or die "Failed to close $file: $!";
}

1;

__END__
