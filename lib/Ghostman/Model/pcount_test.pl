#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';
use Mojo::JSON qw(to_json from_json);
use Data::Dumper;

use lib '.';
use Pcountchk;

###my $instance = Pcountchk->new("instance-1.backbone.site:3000");
my $instance = Pcountchk->new("10.140.0.2:3000");

my $str = $instance->string;
say "string: $str";

my $check = $instance->check;
say "check: $check";

my $gacccheck = $instance->gacccheck;
say "gacccheck: $gacccheck";

my $flag = $instance->flag;
say "flag: $flag";

my $text = to_json($instance->result);

say $text;
