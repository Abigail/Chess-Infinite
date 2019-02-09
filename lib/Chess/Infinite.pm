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

#
# Pieces
#

my @CHESS          = qw [King Queen Rook Bishop Knight];
my @CHESS_COMBINED = qw [Archbishop Chancellor Amazon Samurai Monk];
my @LEAPERS        = qw [Knight Ferz Alfil Tripper Camel Zebra Wazir
                         Dabbaba Threeleaper];
my @OMEGA          = qw [Champion Wizard];
my @XIANGQI        = qw [Rook Horse Elephant];
my @SHOGI          = qw [King Rook DragonKing Bishop DragonHorse
                              ShogiKnight
                              GoldGeneral SilverGeneral Lance];
my @LARGE_SHOGI    = qw [DrunkenElephant];

my @PIECES  = do {my %seen; grep {!$seen {$_} ++}
                     @CHESS, @CHESS_COMBINED, @LEAPERS, @OMEGA, @XIANGQI,
                     @SHOGI, @LARGE_SHOGI};

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
        $full_name {$str} = [$piece_name, $class];
        foreach my $n (1 .. length $str) {
            my $prefix = substr $str, 0, $n;
            #
            # First come, first serve.
            #
            $prefix_name {$prefix} //= [$piece_name, $class];
        }
    }
}

sub piece ($name, @args) {
    my $str  = (lc $name) =~ s/[^a-z0-9]+//gr;
    my $info = $full_name {$str} || $prefix_name {$str} or return;

    my ($piece_name, $class) = @$info;

    $class -> new -> init (@args, name => $piece_name);
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
