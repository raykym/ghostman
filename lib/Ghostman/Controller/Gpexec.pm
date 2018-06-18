package Ghostman::Controller::Gpexec;
use Mojo::Base 'Mojolicious::Controller';

sub ghostexec {
  my $self = shift;

  my $targetname = $self->param('target'); # program name
     if (! defined $targetname) { return; }
  my $account = $self->param('acc');
     if (! defined $account) { return;}
  my $accpass = $self->param('pass');
     if (! defined $accpass) { return;}
  my $lat = $self->param('lat');
     if ( ! defined $lat) { return; }
  my $lng = $self->param('lng');
     if ( ! defined $lng) { return; }

  my $chg_lat = $lat + rand(0.01) - rand(0.01);
  my $chg_lng = $lng + rand(0.01) - rand(0.01);

  my $mode = "random";

  system("sudo systemd-run --scope -p MemoryAccounting=true -p MemoryLimit=130M --uid=1001 /home/debian/perlwork/work/Walkworld/$targetname\.pl $account $accpass $chg_lat $chg_lng $mode > /dev/null 2>&1 & ");

   $self->res->headers->header("Access-Control-Allow-Origin" => 'https://www.backbone.site' );
   $self->render(msg => 'dummy page');
}

sub gaccexec {
   my $self = shift;

   my $sid = $self->param('sid');
     if ( ! defined $sid) { return; }

#     system("/home/debian/perlwork/work/Walkworld/npcuser_n_sitedb.pl $sid & ");
     system("/home/debian/perlwork/work/Walkworld/npcuser_n_sitedb_w.pl $sid > /dev/null 2>&1 & ");  # westwind
#     system("sudo systemd-run --scope -p MemoryAccounting=true -p MemoryLimit=175M --uid=1001 /home/debian/perlwork/work/Walkworld/npcuser_n_sitedb.pl $sid > /dev/null 2>&1 & ");

   $self->res->headers->header("Access-Control-Allow-Origin" => 'https://www.backbone.site' );
   $self->render(msg => 'dummy page');
}

sub gaccexecminion {
   my $self = shift;

   my $sid = $self->param('sid');
     if ( ! defined $sid) { return; }

     $self->app->minion->add_task( gaccexec => sub {
		     my ($job, @args ) = @_;
		     my $sid = $args[0];

                     system("/home/debian/perlwork/work/Walkworld/npcuser_n_sitedb_w.pl $sid > /dev/null 2>&1 & ");  # westwind
     });

   $self->app->minion->enqueue( gaccexec => [ $sid ] );
   $self->app->minion->perform_jobs;

   $self->res->headers->header("Access-Control-Allow-Origin" => 'https://www.backbone.site' );
   $self->render(text => 'dummy page', status => '200');
}

1;
