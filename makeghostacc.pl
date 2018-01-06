#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

# useage :  makeghostacc.pl 1 100
# ghostman.confに追記するためのアカウント情報の生成 viなどで追記すること


if (!@ARGV) {
    exit;
}

for (my $i=$ARGV[0]; $i<= $ARGV[1] ; $i++){

say "                  {\"email\" => \'ghostacc$i\@backbone.site\', \"emailpass\" => \"ghostacc$i\_pass\", \"icon_url\" => \"\", \"userid\" => \"\", \"run\" => \"\", \"name\" => \"ghostacc$i\", \"geometry\" => { \"type\" => \"Point\", \"coordinates\" => [0,0]}, \"loc\" => {\"lat\" => 0, \"lng\" => 0}, \"status\" => \"\", \"rundirect\" => \"\", \"target\" => \"\", \"category\" => \"NPC\", \"ttl\" => \"\", \"place\" => { \"lat\" => \"\", \"lng\" => \"\", \"name\" => \"\"}, \"point_spn\" => \"\", \"lifecount\" => \"\"},"

} # for


