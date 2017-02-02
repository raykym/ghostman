package Ghostman;
use Mojo::Base 'Mojolicious';

#use Ghostman::Model;
#has 'model' => sub { Ghostman::Model->new };

# This method will run once at server start
sub startup {
  my $self = shift;
     
  # hypnotoad start
  $self->config(hypnotoad=>{
                    #   listen => ['https://*:3000?cert=/etc/letsencrypt/live/instance-1.backbone.site/fullchain.pem&key=/etc/letsencrypt/live/instance-1.backbone.site/privkey.pem'],
                       listen => ['http://*:3000'],
                       accepts => 10,
                       clients => 1,
                       workers => 1,
                       proxy => 0,
                       });

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  # config read
  $self->plugin('Config');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');

  $r->any('/ghostman')->to(controller => 'ghostman', action => 'put');


  $r->any('/ghostmang')->to(controller => 'ghostman', action => 'controll');

  $r->get('/pcount')->to(controller => 'Gpcount', action => 'pcount');

  $r->post('/ghostexec')->to(controller => 'Gpexec', action => 'ghostexec');

  $r->any('*')->to('Top#unknown'); # 未定義のパスは全てunknown画面へ
}

1;
