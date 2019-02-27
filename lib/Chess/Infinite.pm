package Chess::Infinite;

use 5.028;
use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

our $VERSION = '2019012901';

use Exporter ();
our @ISA    = qw [Exporter];
our @EXPORT = qw [piece];

use Chess::Infinite::Grapher;

#
# Boards
#
use Chess::Infinite::Board::Spiral;
use Chess::Infinite::Board::Triangle;
use Chess::Infinite::Board::Square;

my %Betza = (
    #
    # Western Chess
    #
    Rook              =>  'R',
    Knight            =>  'N',
    Bishop            =>  'B',
    King              =>  'K',
    Queen             =>  'Q',

    #
    # Combined Chess Pieces
    #
    Archbishop        =>  'BN',           # Bishop + Knight, Capablanca Chess
    Chancellor        =>  'RN',           # Rook + Knight, Capablanca Chess
    Amazon            =>  'QN',           # Queen + Knight
    Samurai           =>  'KN',           # King + Knight, Chakra Chess
    Monk              =>  'WB',           # King + Bishop = Wazir + Bishop,
                                          #    Chakra Chess
    DragonKing        =>  'FR',           # King + Rook = Ferz + Rook, Shogi

    #
    # Basic leapers
    #
    Wazir             =>  'W',
    Ferz              =>  'F',
    Dabbada           =>  'D',
    Alfil             =>  'A',
    Threeleaper       =>  'H',
    Camel             =>  'L',
    Zebra             =>  'J',
    Tripper           =>  'G',

    #
    # Riders
    #
    KnightRider       =>  'N0',

    #
    # Omega Chess
    #
    Champion          =>  'WAD',
    Wizard            =>  'LF',

    #
    # Shogi
    #
    DragonHorse       =>  'BW',

    #
    # Xiangqi
    #
);

my %Alternative_Names = (
    Cardinal          =>  'Archbishop',   # Grand Chess
    Centaurus         =>  'Archbishop',   # Carrera's Chess
    Chariot           =>  'Rook',         # Xiangqi, Chaturanga
    Commoner          =>  'King',
    CrownedBishop     =>  'Monk',
    CrownedKing       =>  'DragonKing',
    CrownedKnight     =>  'Samurai',
    DragonHorse       =>  'Monk',         # Shogi
    Empress           =>  'Chancellor',   # Used by problemists
    Fox               =>  'Archbishop',   # Wolf Chess
    Guard             =>  'King',         # Chess on an infinite plane
    Janus             =>  'Archbishop',   # Janus Chess
    KnightedBishop    =>  'Archbishop',
    KnightedKing      =>  'Samurai',
    KnightedRook      =>  'Chancellor',
    Maharadja         =>  'Amazon',
    Man               =>  'King',         # Quattrochess
    Mann              =>  'King',         # Quattrochess
    Marshall          =>  'Chancellor',   # The Sultan's Game
    Princess          =>  'Archbishop',   # Used by problemists
    PromotedRook      =>  'DragonKing',   # Shogi
    Spy               =>  'King',         # Waterloo Chess
    Vizir             =>  'Archbishop',   # Turkish Grand Chess
    WarMachine        =>  'Chancellor',   # Turkish Great Chess
    Wolf              =>  'Chancellor',   # Wolf Chess
);

#
# Pieces
#

my @CHESS          = qw [Pawn];
my @CHESS_COMBINED = qw [Falcon Hunter];
my @PAWNS          = qw [Pawn BerolinaPawn Sergeant];
my @XIANGQI        = qw [Horse Elephant];
my @JANGGI         = qw [JanggiElephant];
my @SHOGI          = qw [ShogiKnight GoldGeneral SilverGeneral Lance];
my @NANA_SHOGI     = qw [OrthogonalCube DiagonalCube];
my @LARGE_SHOGI    = qw [DrunkenElephant];

my @PIECES  = do {my %seen; grep {!$seen {$_} ++}
                     @CHESS, @CHESS_COMBINED, @PAWNS,
                     @XIANGQI, @JANGGI, @SHOGI, @NANA_SHOGI, @LARGE_SHOGI};

my %prefix_name;
my %full_name;

foreach my $piece (@PIECES) {
    my $class = "Chess::Infinite::Piece::$piece";
    eval "use $class; 1" or do "Failed to load $class: $!";

    my %done;
    foreach my $name ($piece, $class -> alternative_names) {
        my $str = (lc $name) =~ s/[^a-z0-9]+//gr;
        if ($full_name {$str}) {
            die "Name class for $piece; $name is already used by class " .
                $full_name {$str} . "\n";
        }
        my $piece_name = $name =~ s/(\p{Ll})(\p{Lu})/$1 $2/gr;
        $full_name {$str} = [$piece_name, $class, 0];
        foreach my $n (1 .. length $str) {
            my $prefix = substr $str, 0, $n;
            #
            # First come, first serve.
            #
            $prefix_name {$prefix} //= [$piece_name, $class, 0];
        }
    }
}

foreach my $alias (keys %Alternative_Names) {
    my $main_name = $Alternative_Names {$alias};
    $Betza {$alias} = $Betza {$main_name};
}

foreach my $name (keys %Betza) {
    my $notation = $Betza {$name};
    my $str = (lc $name) =~ s/[^a-z0-9]+//gr;
    $full_name {$str} = [$name, $notation, 1];
    foreach my $n (1 .. length $str) {
        my $prefix = substr $str, 0, $n;
        $prefix_name {$prefix} //= [$name, $notation, 1];
    }
}

sub piece ($name, @args) {
    my $str  = (lc $name) =~ s/[^a-z0-9]+//gr;
    my $info = $full_name {$str} || $prefix_name {$str} or return;

    my ($piece_name, $class_or_notation, $type) = @$info;

    my @params = (@args, name => $piece_name);
    my $class;
    if ($type == 0) {
        $class = $class_or_notation;
    }
    if ($type == 1) {
        $class = "Chess::Infinite::Piece";
        push @params => Betza => $class_or_notation;
    }

    $class -> new -> init (@params);
}

1;

__END__

=head1 NAME

Chess::Infinite - Abstract

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

=head1 TODO

=head1 SEE ALSO

=head1 DEVELOPMENT

The current sources of this module are found on github,
L<< git://github.com/Abigail/Chess-Infinite.git >>.

=head1 AUTHOR

Abigail, L<< mailto:cpan@abigail.be >>.

=head1 COPYRIGHT and LICENSE

Copyright (C) 2019 by Abigail.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),   
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 INSTALLATION

To install this module, run, after unpacking the tar-ball, the 
following commands:

   perl Makefile.PL
   make
   make test
   make install

=cut
