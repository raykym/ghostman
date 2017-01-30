package Ghostman::Controller::Gpcount;
use Mojo::Base 'Mojolicious::Controller';

use Proc::ProcessTable;

sub pcount {
    my $self = shift;

    my $proceslist = new Proc::ProcessTable;

    my @doaccount;

    # proceslistからnpcuser,searchnpcを抽出して、稼働中のアカウントを確認する
    foreach my $p (@{$proceslist->table}){
        my $line = $p->cmndline;

        if (( $line =~ /npcuser/)&&( $line !~ /systemd-run/)){
            my @pname = split(/ /,$line);

                push ( @doaccount, $pname[2] ); 

            } # if $line npcuser

        if (( $line =~ /searchnpc/)&&( $line !~ /systemd-run/)){
            my @pname = split(/ /,$line);

                push ( @doaccount, $pname[2] ); 

            } # if $line searchnpc
        } #foreach

    my $sendlist = { "acclist" => \@doaccount };

   $self->res->headers->header("Access-Control-Allow-Origin" => 'https://www.backbone.site' );
   $self->render(json => $sendlist);
}

1;
