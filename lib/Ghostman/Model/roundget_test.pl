#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

use lib '.';
use Roundget;

#my @testarray = ( "a","b","c","1","2");
my @testarray = ( "a");

my $instance = Roundget->new(@testarray);

my $res = $instance->array;
say $res;

   $res = $instance->get;
say $res;

   $res = $instance->get;
say $res;

   $res = $instance->get;
say $res;

   $res = $instance->get;
say $res;

   $res = $instance->get;
say $res;

   $res = $instance->get;
say $res;

   $res = $instance->get;
say $res;

   $res = $instance->get;
say $res;

   $res = $instance->get;
say $res;
