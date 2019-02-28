#!/opt/perl/bin/perl

use 5.026;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';

use Chess::Infinite;
use Chess::Infinite::Test;
use Test::More;

my $piece = piece "Janggi Elephant";

test_moves $piece, <<~ "--";
    . n1  .  .  . n1  .
   n1  .  .  .  .  . n1
    .  .  .  .  .  .  .
    .  .  .  *  .  .  .
    .  .  .  .  .  .  .
   n1  .  .  .  .  . n1
    . n1  .  .  . n1  .
--


done_testing;

__END__
