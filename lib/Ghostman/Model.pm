package Ghostman::Model;
use Mojo::Base 'Mojolicious';

use lib '/home/debian/perlwork/mojowork/ghostman/lib/Ghostman/Model';

#use Ghostman::Model::Subls;
has 'subls' => sub { Ghostman::Model::Subls->new };

1;
