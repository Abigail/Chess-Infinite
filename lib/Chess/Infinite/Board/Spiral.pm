package Chess::Infinite::Board::Spiral;

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

our $VERSION = '2019012901';

use Chess::Infinite::Board;
our @ISA = qw [Chess::Infinite::Board];

use List::Util qw [max];
use POSIX      qw [ceil];

#
# Given some coordinates, return the corresponding value.
#
sub to_value ($self, $x, $y) {
    my $max  = max map {abs} $x, $y;

    my $base = (2 * $max - 1) ** 2;

    return $y ==  $max ? $base + 7 * $max + $x 
         : $x == -$max ? $base + 5 * $max + $y
         : $y == -$max ? $base + 3 * $max - $x
         : $x ==  $max ? $base + 1 * $max - $y
         :                die "Cannot map ($x, $y)";

}


#
# Given a value, return the corresponing coordinates.
#
sub to_coordinates ($self, $value) {
    my $base = ceil sqrt $value;
    my $ring = int ($base / 2);  # How far out are we?

    my $lft = $value - (2 * $ring - 1) ** 2;  # How much 'left' in this ring.

    my ($x, $y);
       if ($lft <= 2 * $ring) {$x =      $ring;        $y =      $ring - $lft;}
    elsif ($lft <= 4 * $ring) {$x =  3 * $ring - $lft; $y =     -$ring;}
    elsif ($lft <= 6 * $ring) {$x =     -$ring;        $y = -5 * $ring + $lft;}
    elsif ($lft <= 8 * $ring) {$x = -7 * $ring + $lft; $y =      $ring;}

    wantarray ? ($x, $y) : [$x, $y];
}



1;

__END__
