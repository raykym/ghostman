#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use feature 'say';
use Data::Dumper;

use lib '/home/debian/perlwork/mojowork/server/ghostman/lib/Ghostman/Model';
use Gacclistobj;

my $gacclist = [
                  {"email" => 'ghostacc1@backbone.site', "emailpass" => "ghostacc1_pass", "icon_url" => "", "userid" => "", "run" => "", "name" => "ghostacc1", "geometry" => { "type" => "Point", "coordinates" => [0,0]}, "loc" => {"lat" => 0, "lng" => 0}, "status" => "", "rundirect" => "", "target" => "", "category" => "NPC", "ttl" => "", "place" => { "lat" => "", "lng" => "", "name" => ""}, "point_spn" => "", "lifecount" => ""},
                  {"email" => 'ghostacc2@backbone.site', "emailpass" => "ghostacc2_pass", "icon_url" => "", "userid" => "", "run" => "", "name" => "ghostacc2", "geometry" => { "type" => "Point", "coordinates" => [0,0]}, "loc" => {"lat" => 0, "lng" => 0}, "status" => "", "rundirect" => "", "target" => "", "category" => "NPC", "ttl" => "", "place" => { "lat" => "", "lng" => "", "name" => ""}, "point_spn" => "", "lifecount" => ""},
                  {"email" => 'ghostacc3@backbone.site', "emailpass" => "ghostacc3_pass", "icon_url" => "", "userid" => "", "run" => "", "name" => "ghostacc3", "geometry" => { "type" => "Point", "coordinates" => [0,0]}, "loc" => {"lat" => 0, "lng" => 0}, "status" => "", "rundirect" => "", "target" => "", "category" => "NPC", "ttl" => "", "place" => { "lat" => "", "lng" => "", "name" => ""}, "point_spn" => "", "lifecount" => ""},
                  {"email" => 'ghostacc4@backbone.site', "emailpass" => "ghostacc4_pass", "icon_url" => "", "userid" => "", "run" => "", "name" => "ghostacc4", "geometry" => { "type" => "Point", "coordinates" => [0,0]}, "loc" => {"lat" => 0, "lng" => 0}, "status" => "", "rundirect" => "", "target" => "", "category" => "NPC", "ttl" => "", "place" => { "lat" => "", "lng" => "", "name" => ""}, "point_spn" => "", "lifecount" => ""},
                  {"email" => 'ghostacc5@backbone.site', "emailpass" => "ghostacc5_pass", "icon_url" => "", "userid" => "", "run" => "", "name" => "ghostacc5", "geometry" => { "type" => "Point", "coordinates" => [0,0]}, "loc" => {"lat" => 0, "lng" => 0}, "status" => "", "rundirect" => "", "target" => "", "category" => "NPC", "ttl" => "", "place" => { "lat" => "", "lng" => "", "name" => ""}, "point_spn" => "", "lifecount" => ""},

                ];


  my $ghostlist = Gacclistobj->new($gacclist);

#  my $string = $ghostlist->string;
#
#     for my $i (@$string){
#         say "$i->{name} $i->{userid}";
#     }

#     $ghostlist->makelist;

  my $result = $ghostlist->result;

    for my $i (@$result){
        say "$i->{name} $i->{userid}";

    }



