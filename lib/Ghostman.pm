package Ghostman;
use Mojo::Base 'Mojolicious';
use Mojo::Redis2;

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

   # $self->app->redis
   $self->app->helper( redis =>
         ### sub { shift->stash->{redis} ||= Mojo::Redis2->new(url => 'redis://10.140.0.4:6379');
         sub { state $redis = Mojo::Redis2->new(url => 'redis://10.140.0.4:6379');
         });

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  # config read
  $self->plugin('Config');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
  # 単独プロセス生成
  $r->any('/ghostman')->to(controller => 'ghostman', action => 'put');
  # npcuser_n_site.pl展開形
  $r->any('/ghostmang')->to(controller => 'ghostman', action => 'controll');
  $r->get('/pcount')->to(controller => 'Gpcount', action => 'pcount');
  $r->post('/ghostexec')->to(controller => 'Gpexec', action => 'ghostexec');

  # npcuser_n_sitedb.pl展開用
  $r->post('/gaccput')->to(controller => 'ghostman', action => 'gaccput');
 # $r->post('/gacclist')->to(controller => 'ghostman', action => 'gacclist'); # 仕様変更廃止
  $r->post('/gaccexec')->to(controller => 'Gpexec', action => 'gaccexec');
  $r->get('/gaccpcount')->to(controller => 'Gpcount', action => 'gaccpcount');

  $r->any('*')->to('Top#unknown'); # 未定義のパスは全てunknown画面へ
}

1;
