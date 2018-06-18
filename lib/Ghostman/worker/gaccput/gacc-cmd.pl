#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use feature 'say';

# gaccputのminion状況を確認するコマンド
# >gacc-cmd.pl stat | reset

use Minion;
use Data::Dumper;
 
# Connect to backend
my $minion = Minion->new(Pg => 'postgresql://minion:minionpass@localhost/minion');

if (( ! defined $ARGV[0] ) || ( $ARGV[0] eq "")) {
    say ">gacc-cmd.pl stat | reset ";
    exit;
}

if ($ARGV[0] eq 'reset' ) {
    # reset
    my $stat = $minion->stats;
    say Dumper $stat;
    $minion->reset;
    $stat = $minion->stats;
    say Dumper $stat;
    exit;
}


if ( $ARGV[0] eq 'stat' ) {
   my $stat = $minion->stats;
   say Dumper $stat;
   exit;
}


if ( $ARGV[0] eq 'tasks' ) {
   my $tasks = $minion->tasks;
   say Dumper $tasks;
   exit;
}

if ( $ARGV[0] eq 'history' ) {
   my $history = $minion->history;
   say Dumper $history;
   exit;
}
