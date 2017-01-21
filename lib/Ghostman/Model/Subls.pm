package Ghostman::Model::Subls;
use Mojo::Base 'Mojolicious';


# $glistを受け取って、チェックして返す $self->app->model->subls->npcProcChk
sub npcProcChk{
    my ($self,$glist) = @_;
 
use Proc::ProcessTable;

  my $proceslist = new Proc::ProcessTable;

  # proceslistからnpcuserを抽出して、稼働中のアカウントを確認する
  foreach my $p (@{$proceslist->table}){
      my $line = $p->cmndline;
      if ( $line =~ /npcuser/ ){
          my @pname = split(/ /,$line);

          for my $i (@$glist){
              if ($pname[2] eq $i->{email}) {
                                          $i->{run} = "exist";
                                          } else {
                                          $i->{run} = "";
                                          }
            } #for
          } # if $line

      } #foreach

  return $glist;
}

1;
