package Ghostman;
use Mojo::Base 'Mojolicious';
use Mojo::Redis2;
use Mojo::Pg;
use Minion;
use Mojolicious::Plugin::Minion;

#use Ghostman::Model;
#has 'model' => sub { Ghostman::Model->new };

use lib '/home/debian/perlwork/mojowork/server/ghostman/lib/Ghostman/Model';
use Gacclistobj;

# This method will run once at server start
sub startup {
  my $self = shift;
     
  # hypnotoad start
  $self->config(hypnotoad=>{
                    #   listen => ['https://*:3000?cert=/etc/letsencrypt/live/instance-1.backbone.site/fullchain.pem&key=/etc/letsencrypt/live/instance-1.backbone.site/privkey.pem'],
                       listen => ['http://*:3000'],
                       accepts => 1000,
                       clients => 1,
                       workers => 10,
                       proxy => 1,
                       });

  # config read
  $self->plugin('Config');

  my $redisserver = $self->app->config->{redisserver};
  my $postgresserver = $self->app->config->{postgresserver};

   # $self->app->redis
   $self->app->helper( redis =>
         ### sub { shift->stash->{redis} ||= Mojo::Redis2->new(url => 'redis://10.140.0.4:6379');
         sub { state $redis = Mojo::Redis2->new(url => "redis://$redisserver:6379");
         });

   # $self->app->pg
   $self->app->helper ( pg =>
           sub { state $pg = Mojo::Pg->new( 'postgresql://minion:minionpass@localhost/minion' );
         });

   $self->plugin( Minion => { Pg => $self->app->pg });


  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');


#  #稼働中はリストが保持される前提  useridを一意にするため
  my $gacclist = $self->app->config->{ghostacc};
#  # useridを割り振る
#    foreach my $acc (@$gacclist){
#          if ($acc->{userid} eq ""){
#              $acc->{userid} = Sessionid->new($acc->{email})->uid;
#              $self->app->log->info("DEBUG: set $acc->{email}");
#          } #if
#    }
  $self->app->helper( ghostlist => sub { state $ghostlist = Gacclistobj->new($gacclist) });

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
  $r->post('/gaccputminion')->to(controller => 'ghostman', action => 'gaccputminion');  # Minion利用
 # $r->post('/gacclist')->to(controller => 'ghostman', action => 'gacclist'); # 仕様変更廃止
  $r->post('/gaccexec')->to(controller => 'Gpexec', action => 'gaccexec');
  $r->post('/gaccexecminion')->to(controller => 'Gpexec', action => 'gaccexecminion');
  $r->get('/gaccpcount')->to(controller => 'Gpcount', action => 'gaccpcount');

  $r->any('*')->to('Top#unknown'); # 未定義のパスは全てunknown画面へ
}

1;
