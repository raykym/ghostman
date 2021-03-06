package Ghostman::Controller::Ghostman;
use Mojo::Base 'Mojolicious::Controller';

use Proc::ProcessTable;
use Mojo::JSON qw(encode_json decode_json from_json to_json);
use Mojo::UserAgent;
use Mojo::Redis2;

use AnyEvent;
use EV;

# 独自パスを指定して自前モジュールを利用
use lib '/home/debian/perlwork/mojowork/server/ghostman/lib/Ghostman/Model';
use Pcountchk;
use Roundget;
use Sessionid;

# This action will render a template
sub put {
  my $self = shift;

  my $gcount = $self->param('c'); # ghost数
     if (! defined $gcount) { return; }

  my $lat = $self->param('lat');
     if ( ! defined $lat) { return; }
  my $lng = $self->param('lng');
     if ( ! defined $lng) { return; }
#  my $target = $self->param('target');
#     if ( ! defined $target) { return; }


  my $glist = [
               {"email" => 'npcuser1@test.com', "emailpass" => "npcuser1_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser2@test.com', "emailpass" => "npcuser2_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser3@test.com', "emailpass" => "npcuser3_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser4@test.com', "emailpass" => "npcuser4_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser5@test.com', "emailpass" => "npcuser5_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser6@test.com', "emailpass" => "npcuser6_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser7@test.com', "emailpass" => "npcuser7_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser8@test.com', "emailpass" => "npcuser8_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser9@test.com', "emailpass" => "npcuser9_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser10@test.com', "emailpass" => "npcuser10_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser11@test.com', "emailpass" => "npcuser11_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser12@test.com', "emailpass" => "npcuser12_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser13@test.com', "emailpass" => "npcuser13_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser14@test.com', "emailpass" => "npcuser14_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser15@test.com', "emailpass" => "npcuser15_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser16@test.com', "emailpass" => "npcuser16_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser17@test.com', "emailpass" => "npcuser17_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser18@test.com', "emailpass" => "npcuser18_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser19@test.com', "emailpass" => "npcuser19_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser20@test.com', "emailpass" => "npcuser20_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser21@test.com', "emailpass" => "npcuser21_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser22@test.com', "emailpass" => "npcuser22_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser23@test.com', "emailpass" => "npcuser23_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser24@test.com', "emailpass" => "npcuser24_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser25@test.com', "emailpass" => "npcuser25_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser26@test.com', "emailpass" => "npcuser26_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser27@test.com', "emailpass" => "npcuser27_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser28@test.com', "emailpass" => "npcuser28_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser29@test.com', "emailpass" => "npcuser29_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser30@test.com', "emailpass" => "npcuser30_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser31@test.com', "emailpass" => "npcuser31_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser32@test.com', "emailpass" => "npcuser32_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser33@test.com', "emailpass" => "npcuser33_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser34@test.com', "emailpass" => "npcuser34_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser35@test.com', "emailpass" => "npcuser35_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser36@test.com', "emailpass" => "npcuser36_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser37@test.com', "emailpass" => "npcuser37_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser38@test.com', "emailpass" => "npcuser38_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser39@test.com', "emailpass" => "npcuser39_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'npcuser40@test.com', "emailpass" => "npcuser40_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'npcuser41@test.com', "emailpass" => "npcuser41_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'npcuser42@test.com', "emailpass" => "npcuser42_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'npcuser43@test.com', "emailpass" => "npcuser43_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'npcuser44@test.com', "emailpass" => "npcuser44_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'npcuser45@test.com', "emailpass" => "npcuser45_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'npcuser46@test.com', "emailpass" => "npcuser46_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'npcuser47@test.com', "emailpass" => "npcuser47_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'npcuser48@test.com', "emailpass" => "npcuser48_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'npcuser49@test.com', "emailpass" => "npcuser49_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'npcuser50@test.com', "emailpass" => "npcuser50_pass", "mode" => "random", "run" =>""} ,
            ];

  my $sglist = [
               {"email" => 'searchnpc1@test.com', "emailpass" => "searchnpc1_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc2@test.com', "emailpass" => "searchnpc2_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc3@test.com', "emailpass" => "searchnpc3_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc4@test.com', "emailpass" => "searchnpc4_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc5@test.com', "emailpass" => "searchnpc5_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc6@test.com', "emailpass" => "searchnpc6_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc7@test.com', "emailpass" => "searchnpc7_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc8@test.com', "emailpass" => "searchnpc8_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc9@test.com', "emailpass" => "searchnpc9_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc10@test.com', "emailpass" => "searchnpc10_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc11@test.com', "emailpass" => "searchnpc11_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc12@test.com', "emailpass" => "searchnpc12_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc13@test.com', "emailpass" => "searchnpc13_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc14@test.com', "emailpass" => "searchnpc14_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc15@test.com', "emailpass" => "searchnpc15_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc16@test.com', "emailpass" => "searchnpc16_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc17@test.com', "emailpass" => "searchnpc17_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc18@test.com', "emailpass" => "searchnpc18_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc19@test.com', "emailpass" => "searchnpc19_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc20@test.com', "emailpass" => "searchnpc20_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc21@test.com', "emailpass" => "searchnpc21_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc22@test.com', "emailpass" => "searchnpc22_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc23@test.com', "emailpass" => "searchnpc23_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc24@test.com', "emailpass" => "searchnpc24_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc25@test.com', "emailpass" => "searchnpc25_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc26@test.com', "emailpass" => "searchnpc26_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc27@test.com', "emailpass" => "searchnpc27_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc28@test.com', "emailpass" => "searchnpc28_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc29@test.com', "emailpass" => "searchnpc29_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc30@test.com', "emailpass" => "searchnpc30_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc31@test.com', "emailpass" => "searchnpc31_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc32@test.com', "emailpass" => "searchnpc32_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc33@test.com', "emailpass" => "searchnpc33_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc34@test.com', "emailpass" => "searchnpc34_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc35@test.com', "emailpass" => "searchnpc35_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc36@test.com', "emailpass" => "searchnpc36_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc37@test.com', "emailpass" => "searchnpc37_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc38@test.com', "emailpass" => "searchnpc38_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc39@test.com', "emailpass" => "searchnpc39_pass", "mode" => "random", "run" =>""} ,
               {"email" => 'searchnpc40@test.com', "emailpass" => "searchnpc40_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'searchnpc41@test.com', "emailpass" => "searchnpc41_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'searchnpc42@test.com', "emailpass" => "searchnpc42_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'searchnpc43@test.com', "emailpass" => "searchnpc43_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'searchnpc44@test.com', "emailpass" => "searchnpc44_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'searchnpc45@test.com', "emailpass" => "searchnpc45_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'searchnpc46@test.com', "emailpass" => "searchnpc46_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'searchnpc47@test.com', "emailpass" => "searchnpc47_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'searchnpc48@test.com', "emailpass" => "searchnpc48_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'searchnpc49@test.com', "emailpass" => "searchnpc49_pass", "mode" => "random", "run" =>""} ,
         #      {"email" => 'searchnpc50@test.com', "emailpass" => "searchnpc50_pass", "mode" => "random", "run" =>""} ,
             ];
  

  my $proceslist = new Proc::ProcessTable;

  # clear set
#  foreach my $j (@$glist){
#        $j->{run} = "";
#      }

  # proceslistからnpcuser,searchnpcを抽出して、稼働中のアカウントを確認する
  foreach my $p (@{$proceslist->table}){
      my $line = $p->cmndline;

      if ( $line =~ /npcuser/){
          my @pname = split(/ /,$line);
         
          for my $i (@$glist){
              if ( $pname[2] eq $i->{email}) {
                                          $i->{run} = "exist";
                                          } 
            } #for
          } # if $line npcuser

      if ( $line =~ /searchnpc/){
          my @pname = split(/ /,$line);
         
          for my $i (@$sglist){
              if ( $pname[2] eq $i->{email}) {
                                          $i->{run} = "exist";
                                          } 
            } #for
          } # if $line searchnpc
      } #foreach

   # DEBUG:
   my $debg = to_json($glist);
   $self->app->log->debug("DEBUG: glist: $debg");
   my $debg_s = to_json($sglist);
   $self->app->log->debug("DEBUG: sglist: $debg_s");

   #$gcount数だけ、実行を始める
   for ( my $count=0 ; $count < $gcount; $count++){
       foreach my $pro (@$glist){ 
           if ($pro->{run} eq "") {
              my $chg_lat = $lat + rand(0.01) - rand(0.01);
              my $chg_lng = $lng + rand(0.01) - rand(0.01);
           ###   system("/home/debian/perlwork/work/Walkworld/npcuser_n_site.pl $pro->{email} $pro->{emailpass} $chg_lat $chg_lng $pro->{mode} 2 >> /home/debian/perlwork/work/Walkworld/npcuser_multi.log & ");
              system("/home/debian/perlwork/work/Walkworld/npcuser_n_site.pl $pro->{email} $pro->{emailpass} $chg_lat $chg_lng $pro->{mode} > /dev/null 2>&1 & ");
              $pro->{run} = "exist";
              $self->app->log->debug("DEBUG: $pro->{email} start");
              last;
           } #if
       } # foreach
   }  #for

   for ( my $count=0 ; $count < $gcount; $count++){
       foreach my $pro (@$sglist){ 
           if ($pro->{run} eq "") {
              my $chg_lat = $lat + rand(0.01) - rand(0.01);
              my $chg_lng = $lng + rand(0.01) - rand(0.01);
          ###    system("/home/debian/perlwork/work/Walkworld/searchnpc_n_site.pl $pro->{email} $pro->{emailpass} $chg_lat $chg_lng $pro->{mode} 2 >> /home/debian/perlwork/work/Walkworld/searchnpc_multi.log & ");
              system("/home/debian/perlwork/work/Walkworld/searchnpc_n_site.pl $pro->{email} $pro->{emailpass} $chg_lat $chg_lng $pro->{mode} > /dev/null 2>&1 & ");
              $pro->{run} = "exist";
              $self->app->log->debug("DEBUG: $pro->{email} start");
              last;
           } #if
       } # foreach
   }  #for

   $self->res->headers->header("Access-Control-Allow-Origin" => 'https://www.backbone.site' );
 #  $self->res->headers->header("Access-Control-Allow-Origin" => 'https://westwind.iobb.net' );
   $self->render(msg => 'dummy page');
}


sub controll {
  my $self = shift;
  # 負荷分散用、スケール可能な形に処理を分割した
  # アカウントリストとホストリストは外出し

  my $gcount = $self->param('c'); # ghost数
     if (! defined $gcount) { return; }
  my $lat = $self->param('lat');
     if ( ! defined $lat) { return; }
  my $lng = $self->param('lng');
     if ( ! defined $lng) { return; }

  #アカウントリストの設定  外部ファイルにした結果、読み替えを行わないとリストがリセットされない
  my $glist_tmp = $self->app->config->{glist};
  my $glist = $glist_tmp;
  my $sglist_tmp = $self->app->config->{sglist};
  my $sglist = $sglist_tmp;

# hostlist たぶん30個が限界　event emitterで時間切れが起きる チェックエラーが起きる場合も2重起動を引き起こす
  my $hostlist_tmp = $self->app->config->{hostlist}; #configに書けるのはハッシュのみなので、ステップを置いて配列に置き換える
  my @hostlist = @$hostlist_tmp;
  undef $hostlist_tmp;

#  my @hostlist = ( 
#                   "10.140.0.2:3000",
#                   "10.140.0.5:3000",
#                 );

  my @pcountlist = ();
  my @pcountres = ();  # 実行中のアカウントリストの結果
  my @drophost =(); #除外サーバリスト
  my $ua = Mojo::UserAgent->new;

  #host check
  foreach my $host (@hostlist){
    my $tx = $ua->get("http://$host");     
       if (! $tx->success) {
           push( @drophost , $host);
           $self->app->log->debug("DEBUG: host check: $host DROPed.....");
          }
    }

   my @hosts; #drophostとhostlistの差分
   foreach my $po (@hostlist){
               push(@hosts,$po) unless grep { $_ =~ $po } @drophost;
           }  

  foreach my $host (@hosts){
      push (@pcountlist , Pcountchk->new($host));
  }

  foreach my $instance (@pcountlist) {
      my $ret = $instance->check;
      if ( $ret == 0 ){
             my $res = $instance->result;
             my $res_j = to_json($res);
             push (@pcountres, $res);
             $self->app->log->debug("DEBUG: pcount(true): $res_j" );
         } else {
             #retry
             my $ret = $instance->check;
             if ($ret == 0){
                 my $res = $instance->resilt;
                 my $res_j = to_json($res);
                 push (@pcountres, $res);
                 $self->app->log->debug("DEBUG: pcount2(true): $res_j" );
             } else {
                 my $res = $instance->result;
                 my $res_j = to_json($res);    # 空白80個で強制的にdropさせる
                 my $dumdata = {"acclist" => ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""] };
                 push (@pcountres, $dumdata);
                 $self->app->log->debug("DEBUG: pcount2(error): $res_j" );
             } #flag2
         } # flag1
  } #foreach

  undef @pcountlist;

  # プロセス数の上限とサーバ個別上限の確認
    my $proclimit = 70; #1サーバ当たり70プロセスが上限とする（standard　3.75GB）
    my $allprocs = 0;
    for (my $j=0; $j <= $#pcountres; $j++){
        my $i = $pcountres[$j]->{acclist};
           my @ii = @$i;
           $allprocs = $allprocs + $#ii + 1;

           $self->app->log->debug("DEBUG: acclist $j | count: $#ii ");

           # 上限に達しているサーバをリストする
           if ( $#ii >= ($proclimit -1) ) {
              push (@drophost, $hostlist[$j]); 
              $self->app->log->debug("DROP hostlist: $hostlist[$j] ");
              }
    } # for

    $self->app->log->debug("DEBUG: allprocs: $allprocs ");

    my $limitcount = $proclimit * ($#hosts + 1 );

    $self->app->log->debug("DEBUG: limitcount: $limitcount ");

    if ( $limitcount < $allprocs) {
           $self->app->log->debug("allprocs: $allprocs  NOT EXEC NPC.........");
           return;  # 上限を超えてプロセスは起動させない
        }

# host毎の起動プロセス数と利用アカウントのチェック  @hostlistと@pcountresは位置で一致する前提
  my $hostprocs = {}; #host毎のプロセス数

  foreach my $host (@hosts){
      #host中の稼働プロセス数     
      my $hps = shift(@pcountres);   # @pcountresは消えていく
      my $haccs_tmp = $hps->{acclist}; 
      my @haccs = @$haccs_tmp;
         $hostprocs = { %$hostprocs, $host =>  $#haccs + 1 };   #連想配列の追加

      # 利用アカウントのチェック
          foreach my $j (@haccs){
            if ($j =~ /npcuser/) {
              for my $i (@$glist){
                  if ( $j eq $i->{email}) {
                                              $i->{run} = "exist";
                                              $self->app->log->debug("DEBUG: $i->{email} EXIST");
                                              }
                } #for
             } #if npcuser

            if ($j =~ /searchnpc/ ){
              for my $i (@$sglist){
                  if ( $j eq $i->{email}) {
                                              $i->{run} = "exist";
                                              $self->app->log->debug("DEBUG: $i->{email} EXIST");
                                              }
                } #for
              } # if $j
          } #foreach @haccs
      } #foreach @hosts

      my $debugvar = to_json($hostprocs);
      $self->app->log->debug("DEBUG: hostprocs: $debugvar");
      undef $debugvar;
      undef $hostprocs;

### host振り分けの方法とアカウント選択方法の検討中
# メモリー使用量がネックなので、80プロセスで上限を設定する。ラウンドロビンにするか。。。
# Roundgetでラウンドロビンを行う
# $gcount を2種類実行する。

 #  my @hosts; #drophostとhostlistの差分 上で定義済
   foreach my $po (@hostlist){
               push(@hosts,$po) unless grep { $_ =~ $po } @drophost;
           }  

   if ( $hosts[0] eq "" ) { return; }    # @hostsが０ならパス

   my $hostget = Roundget->new(@hosts);

   #$gcount数だけ、実行を始める
   for ( my $count=0 ; $count < $gcount; $count++){
       foreach my $pro (@$glist){
           if ($pro->{run} eq "") {
              my $hostname = $hostget->get;
              my $cmdline = "npcuser_n_site";

                 $ua->post("http://$hostname/ghostexec" => form => { target => $cmdline, acc => $pro->{email}, pass => $pro->{emailpass} ,lat => $lat, lng => $lng });

              $pro->{run} = "exist";
              $self->app->log->debug("DEBUG: $pro->{email} start");
              last;
           } #if
       } # foreach
   }  #for

   for ( my $count=0 ; $count < $gcount; $count++){
       foreach my $pro (@$sglist){
           if ($pro->{run} eq "") {
              my $hostname = $hostget->get;
              my $cmdline = "searchnpc_n_site";

                 $ua->post("http://$hostname/ghostexec" => form => { target => $cmdline, acc => $pro->{email}, pass => $pro->{emailpass} ,lat => $lat, lng => $lng });
              $pro->{run} = "exist";
              $self->app->log->debug("DEBUG: $pro->{email} start");
              last;
           } #if
       } # foreach
   }  #for

   undef @hosts;
   undef @drophost;

   undef $glist;
   undef $sglist;

   $self->res->headers->header("Access-Control-Allow-Origin" => 'https://www.backbone.site' );
   $self->render(msg => 'dummy page');
}


sub gaccput {
    my $self = shift;

    # 稼働中のアカウントをチェックして、割り振るだけ、終了はコプロで処理される
    # ラウンドロビンで振り分け可能とする。受け入れに失敗すると無視されるだけ。再度受け付けて処理されるはず。

  my $gcount = $self->param('c'); # ghost数
     if (! defined $gcount) { return; }
  my $lat = $self->param('lat');
     if ( ! defined $lat) { return; }
  my $lng = $self->param('lng');
     if ( ! defined $lng) { return; }

  $self->app->log->info("DEBUG: gaccput on message: $gcount $lat $lng");

  # config read
  $self->app->plugin('Config');

  my $redisserver = $self->app->config->{redisserver};

#  my $redis ||= Mojo::Redis2->new(url => 'redis://10.140.0.4:6379');
  my $redis ||= Mojo::Redis2->new(url => "redis://$redisserver:6379");
  my $ua = Mojo::UserAgent->new;

#  #稼働中はリストが保持される前提   startに移動 Gacclistobj.pmに変更　helper->ghostlist
#  my $gacclist = $self->app->config->{ghostacc};
#
#    # useridを割り振る
#    foreach my $acc (@$gacclist){
#          if ($acc->{userid} eq ""){
#              $acc->{userid} = Sessionid->new($acc->{email})->uid;
#              $self->app->log->info("DEBUG: set $acc->{email}");
#          } #if
#    }
  my $gacclist = $self->app->ghostlist->result;;
    
  # Pcountchkにgacccheckを追加した
  # sidのリストが戻る
  # ghostman.confに書き込まれたホストにラウンドで処理を割り当てる
  my $ghostmanhosts = $self->app->config->{ghostmanhosts};
  my $roundget = Roundget->new(@$ghostmanhosts);
  my $host = $roundget->get;
#  my $host = "10.140.0.2:3000";  # 元の形式
  my $pcountchk = Pcountchk->new($host);     # AnyEvent::Condvarでエラーが起きる。　10回で終了　空配列が戻る想定
     $pcountchk->gacccheck; 
  my $res = $pcountchk->result; # $res->{proclist}に配列でsidが入っている
  my @proclist = @{$res->{proclist}};

  # 実行中アカウントのチェック gacclistにrun=existをチェックする
  my @coprolist = ();   # 実行中のアカウント情報の配列の配列 proclistに位置が同じはず配列だから
  my @coprocount = ();  # @coprolistに合わせてカウントする

  $self->app->log-> info("DEBUG: proclist: $#proclist");

  if ($#proclist != -1){  # 空配列ならパス
     for my $i (@proclist){
          my $pacclist;
            $pacclist = $redis->get("GACC$i");
            $pacclist = from_json($pacclist) if ( defined $pacclist);
         push(@coprolist,$pacclist) if ( defined $pacclist); #実行中アカウント情報の配列を取得
         undef $pacclist;
         }

  # 1サーバ当たり5プロセスを上限とする。  もう一度要求が来れば、別のサーバを指定されることで追加されるはず。
  if ($#proclist > 5){ # 5プロセスでリミットを設定しておく 6個まで動くがそうしないと止まってしまう　スケールアウトでラウンドロビンさせる
    $self->res->headers->header("Access-Control-Allow-Origin" => 'https://westwind.backbone.site' );
    $self->render(msg => 'this server limit over');
    return;
    }

      for my $i (@$gacclist){
          $i->{run} = "";  #初期化する。祓われたアカウントをクリアするため
         }
     #gacclistの稼働中チェック 稼働数のカウント
      for my $i (@coprolist){
             my @pcount;  # ARRAYリファレンスではない場合、空白配列のまま
             if (ref($i) eq 'ARRAY') { 
                 @pcount = @$i; 
                }   
             push(@coprocount,$#pcount); # 配列番号(個数-1)または空(-1)に成っている         
             undef @pcount;
          for my $j (@$gacclist){
              if ( grep { $_->{email} eq $j->{email} } @$i) {  #稼働中のアカウントリストを初期リストに突き合せて、稼働中フラグを立てる
                  $j->{run} = "exist";
       #           $self->app->log->info("DEBUG check: $j->{name} $j->{run}");
                 } 
          } #j
      }#i
    $self->app->log->info("DEBUG: Check END!!");
  }  else {   # if @proclist ここまでバイパスする
     $self->app->log->info("DEBUG: @proclist is null!");
  }
my $sid;

  if (!@proclist){
     #子プロセスが無いので準備する。
     $sid = Sessionid->new->sid;
     $ua->post("http://$host/gaccexec" => form => { sid => $sid });   # Roundgetでラウンドロビンに振り分けられる
     $self->app->log->info("DEBUG: procexec: $sid");
     push(@proclist,$sid);
     push(@coprolist,[]);
     push(@coprocount,0);
  }

  # 子プロセスに受け入れる容量が在るのか？確認するには
  my $chkcount;
  for my $i (@coprocount){
       my $j = $i + 1;  # 配列の添字に+1
       $chkcount = $chkcount + ( 200 - $j);  # 空き数チェック　上限を200に想定
  } 
  if ( $chkcount < $gcount ) {
     #子プロセスの空きが要求個数に満たない場合、子プロセスを追加
     $sid = Sessionid->new->sid;
     $ua->post("http://$host/gaccexec" => form => { sid => $sid });
     $self->app->log->info("DEBUG: 2 procexec: $sid");
     push(@proclist,$sid);
     push(@coprolist,[]);
     push(@coprocount,0);
  }
  undef $chkcount;

  my $gaccon = {};

  for (my $i=0; $i<$gcount; $i++){
      for (my $j=0; $j<=$#coprolist; $j++) {
             $self->app->log->info("DEBUG: coprocount: $coprocount[$j]");
          if ( $coprocount[$j] >= 199 ){ #1プロセス当たり200個の上限
               next; # $j up   coprolistを先に進める
              } 

       #   $self->app->log->info("DEBUG: coprolist[$j]: $coprolist[$j]");

          for my $k(@$gacclist){
              if ($k->{run} ne "exist"){
                # uidは上で設定済 
                 $k->{run} = "exist";
                 $lat = $lat + rand(0.005) - rand(0.005); 
                 $lng = $lng + rand(0.005) - rand(0.005);

                 $k->{loc}->{lat} = $lat;
                 $k->{loc}->{lng} = $lng;
                 $k->{geometry}->{coordinates}  = [ $lng , $lat ];

                 my $kjson = to_json($k);
                 $self->app->log->info("DEBUG: gacc: ADD: $kjson");
                 push( @{$coprolist[$j]}, $k);   # 従来のGACCに書き戻す用

                 # GACCon用
                 push(@{$gaccon->{$proclist[$j]}}, $k);   # ハッシュに配列を加える{ $sid => [ $k ] }

        # redis書き込みもここで GACC
    #    my $accdata = to_json($coprolist[$j]);
    #    $redis->set("GACC$proclist[$j]" => $accdata );
    #    $redis->expire("GACC$proclist[$j]" => 32 );
    #    undef $accdata;
    #    $self->app->log->info("DEBUG: redis set: GACC$proclist[$j]");

        # GACCon  多数アカウント一気処理ではここがダメ
    #    my $beforexist;
    #       $beforexist = $redis->get("GACCon$proclist[$j]");
    #    if ( defined $beforexist ) {
    #       my @tmp_k;
    #       my $beforeobj = from_json($beforexist);
    #       push(@tmp_k,$beforexist); 
    #       push(@tmp_k,$k);
    #       $kjson = to_json(\@tmp_k);   # 上書き
    #       undef @tmp_k;
    #    }

        # 追加用GACCon.....に書き込む
    #    $redis->set("GACCon$proclist[$j]" => $kjson );
    #    $redis->expire("GACCon$proclist[$j]" => 10 );
 
        undef $kjson;

    #             $debug = to_json($coprolist[$j]);
    #     $self->app->log->debug("DEBUG: coprolist[$j]: $debug");
    #             undef $debug;
                 last; # 1回処理するとループを抜ける
                 }
             } #for $k 
            last; # 内側ループが処理すると抜ける
          } #$j
    } #$i

#    #redisに書き戻す proclistからsid coprolistでアカウント情報
#    for (my $i=0; $i<=$#proclist; $i++) {
#        my $accdata = to_json($coprolist[$i]);
#        $redis->set("GACC$proclist[$i]" => $accdata );
#        $redis->expire("GACC$proclist[$i]" => 32 );
#        undef $accdata;
#        $self->app->log->info("DEBUG: redis set2: GACC$proclist[$i]");
#    }

        # 追加用GACCon.....に書き込む
        foreach my $key (keys %$gaccon){
            my $gacconjson = to_json(\@{$gaccon->{$key}});
            $redis->set("GACCon$key" => $gacconjson );
            $redis->expire("GACCon$key" => 12 );
            $self->app->log->info("DEBUG: add gaccon: $key | $gacconjson ");
        }

    $self->res->headers->header("Access-Control-Allow-Origin" => 'https://www.backbone.site' );
    $self->render(msg => 'dummy page');

  undef @proclist;
  undef @coprolist;
  undef @coprocount;
  undef $pcountchk;
  undef $gaccon;

}

sub gacclist {
    my $self = shift;
  # 子プロセスからアクセスを受けて、sid毎にアカウントリストを表示する。
  # redisに登録されたリストを返すのみ ->プロセスは直接redisへアクセスするので未使用

    my $sid = $self->param('sid');

#    my $redis = $self->app->redis;
    my $redis ||= Mojo::Redis2->new(url => 'redis://westwind:6379');

    my @list =  $redis->get("GACC$sid");

    my $sendlist = { "acclist" => \@list };


    $self->res->headers->header("Access-Control-Allow-Origin" => 'https://www.backbone.site' );
    $self->render(json => $sendlist);

    undef $sendlist;
    undef @list;
}

sub gaccputminion {
    my $self = shift;

    # 稼働中のアカウントをチェックして、割り振るだけ、終了はコプロで処理される
    # ラウンドロビンで振り分け可能とする。受け入れに失敗すると無視されるだけ。再度受け付けて処理されるはず。

  my $gcount = $self->param('c'); # ghost数
     if (! defined $gcount) { return; }
  my $lat = $self->param('lat');
     if ( ! defined $lat) { return; }
  my $lng = $self->param('lng');
     if ( ! defined $lng) { return; }

  $self->app->log->info("DEBUG: gaccput on message: $gcount $lat $lng");

  # config read
  $self->app->plugin('Config');

  my $redisserver = $self->app->config->{redisserver};

  my $gacclist = $self->app->ghostlist->result;
    
  # Pcountchkにgacccheckを追加した
  # sidのリストが戻る
  # ghostman.confに書き込まれたホストにラウンドで処理を割り当てる
  my $ghostmanhosts = $self->app->config->{ghostmanhosts};
  my $roundget = Roundget->new(@$ghostmanhosts);
  my $host = $roundget->get;


    $self->res->headers->header("Access-Control-Allow-Origin" => 'https://www.backbone.site' );
    $self->render( text => 'dummy page' , status => '200');

  # minion worker task
  $self->app->minion->add_task( gaccput => sub {
            my ($job,@args) = @_;

            my ( $gcount, $lat, $lng, $redisserver, $gacclist, $host  ) = @args;   # 引数を展開

	    use Mojo::JSON qw/from_json to_json/;
	    use Mojo::Redis2;
	    use Mojo::UserAgent;
	    use lib '/home/debian/perlwork/mojowork/server/ghostman/lib/Ghostman/Model';
	    use Pcountchk;
            use Sessionid;


#  my $redis ||= Mojo::Redis2->new(url => 'redis://10.140.0.4:6379');
  my $redis ||= Mojo::Redis2->new(url => "redis://$redisserver:6379");
  my $ua = Mojo::UserAgent->new;

  my $pcountchk = Pcountchk->new($host);     # AnyEvent::Condvarでエラーが起きる。　10回で終了　abort配列が戻る想定 初回は正常終了で空がある
     $pcountchk->gacccheck; 
  my $res = $pcountchk->result; # $res->{proclist}に配列でsidが入っている
  my @proclist = @{$res->{proclist}};

  # 実行中アカウントのチェック gacclistにrun=existをチェックする
  my @coprolist = ();   # 実行中のアカウント情報の配列の配列 proclistに位置が同じはず配列だから
  my @coprocount = ();  # @coprolistに合わせてカウントする

  # Pcountchkがabortなら終了
  if ($proclist[0] eq "abort"){
      $job->app->log->info("DEBUG: proclist: abort END!!!");
      return;
  }

#  $self->app->log-> info("DEBUG: proclist: $#proclist");
  $job->app->log->info("DEBUG: proclist: $#proclist");

   if ($#proclist != -1){  # 空配列ならパス
     for my $i (@proclist){
          my $pacclist;
            $pacclist = $redis->get("GACC$i");
            $pacclist = from_json($pacclist) if ( defined $pacclist);

         my $pacclist_on;
            $pacclist_on = $redis->hvals("GACCon$i");   # 配列にテキストが入ってい

                   for my $i (@$pacclist_on){
                       my $pacclist_one;
                       $pacclist_one = from_json($i) if ( defined $i);
                       if ( defined $pacclist_one ){
                           push(@$pacclist,@$pacclist_one);   # 連想配列に連想配列をつなげる
                           $job->app->log->info("already add pacclist: $i");
                       }
                       undef $pacclist_one;
                   } # for

         push(@coprolist,$pacclist) if ( defined $pacclist); #実行中アカウント情報の配列を取得
         undef $pacclist;
         undef $pacclist_on;
         }


      for my $i (@$gacclist){
          $i->{run} = "";  #初期化する。祓われたアカウントをクリアするため
         }
     #gacclistの稼働中チェック 稼働数のカウント
      for my $i (@coprolist){
             my @pcount;  # ARRAYリファレンスではない場合、空白配列のまま
             if (ref($i) eq 'ARRAY') { 
                 @pcount = @$i; 
                }   
             push(@coprocount,$#pcount); # 配列番号(個数-1)または空(-1)に成っている         
             undef @pcount;
          for my $j (@$gacclist){
              if ( grep { $_->{email} eq $j->{email} } @$i) {  #稼働中のアカウントリストを初期リストに突き合せて、稼働中フラグを立てる
                  $j->{run} = "exist";
       #           $self->app->log->info("DEBUG check: $j->{name} $j->{run}");
                 } 
          } #j
      }#i
  #  $self->app->log->info("DEBUG: Check END!!");
    $job->app->log->info("DEBUG: Check END!!");
  }  else {   # if @proclist ここまでバイパスする
  #   $self->app->log->info("DEBUG: @proclist is null!");
     $job->app->log->info("DEBUG: @proclist is null!");
  }

my $sid;

  if (!@proclist){
     #子プロセスが無いので準備する。
     $sid = Sessionid->new->sid;
     $ua->post("http://$host/gaccexecminion" => form => { sid => $sid });   # Roundgetでラウンドロビンに振り分けられる
  #   $self->app->log->info("DEBUG: procexec: $sid");
     $job->app->log->info("DEBUG: procexec: $sid");
     push(@proclist,$sid);
     push(@coprolist,[]);
     push(@coprocount,0);
  }

  # 子プロセスに受け入れる容量が在るのか？確認するには
  my $chkcount = 100;
  my @chkarray;
  for my $i (@coprocount){
	  #  my $j = $i + 1;  # 配列の添字に+1
	  #  $chkcount = $chkcount - $j;  # 空き数チェック　上限を100に想定
	  if ( $i >= 99) {
              push(@chkarray,1);
	  }
  } 

#  if ( $chkcount < $gcount ) {
  if ( $#chkarray >= $#coprolist ) {
      # 1サーバ当たり5プロセスを上限とする。  もう一度要求が来れば、別のサーバを指定されることで追加されるはず。
      if ($#proclist > 5){ # 5プロセスでリミットを設定しておく 6個まで動くがそうしないと止まってしまう　スケールアウトでラウンドロビンさせる
           #$self->res->headers->header("Access-Control-Allow-Origin" => 'https://westwind.backbone.site' );
	   #$self->render(msg => 'this server limit over');
           return;
       }

     #子プロセスの空きが要求個数に満たない場合、子プロセスを追加
     $sid = Sessionid->new->sid;
     $ua->post("http://$host/gaccexecminion" => form => { sid => $sid });
   #  $self->app->log->info("DEBUG: 2 procexec: $sid");
     $job->app->log->info("DEBUG: 2 procexec: $sid");
     push(@proclist,$sid);
     push(@coprolist,[]);
     push(@coprocount,0);
  }
#  undef $chkcount;
  undef @chkarray;

  my $gaccon = {};

  for (my $i=0; $i<$gcount; $i++){
      for (my $j=0; $j<=$#coprolist; $j++) {
          #   $self->app->log->info("DEBUG: coprocount: $coprocount[$j]");
             $job->app->log->info("DEBUG: coprocount: $coprocount[$j]");
          if ( $coprocount[$j] >= 99 ){ #1プロセス当たり100個の上限
               next; # $j up   coprolistを先に進める
              } 

       #   $self->app->log->info("DEBUG: coprolist[$j]: $coprolist[$j]");

          for my $k(@$gacclist){
              if ($k->{run} ne "exist"){
                # uidは上で設定済 
                 $k->{run} = "exist";
                 $lat = $lat + rand(0.005) - rand(0.005); 
                 $lng = $lng + rand(0.005) - rand(0.005);

                 $k->{loc}->{lat} = $lat;
                 $k->{loc}->{lng} = $lng;
                 $k->{geometry}->{coordinates}  = [ $lng , $lat ];

                 my $kjson = to_json($k);
               #  $self->app->log->info("DEBUG: gacc: ADD: $kjson");
                 $job->app->log->info("DEBUG: gacc: ADD: $kjson");
                 push( @{$coprolist[$j]}, $k);   # 従来のGACCに書き戻す用

                 # GACCon用
                 push(@{$gaccon->{$proclist[$j]}}, $k);   # ハッシュに配列を加える{ $sid => [ $k ] }
 
                 undef $kjson;

    #             $debug = to_json($coprolist[$j]);
    #     $self->app->log->debug("DEBUG: coprolist[$j]: $debug");
    #             undef $debug;
                 last; # 1回処理するとループを抜ける
                 }
             } #for $k 
            last; # 内側ループが処理すると抜ける
          } #$j
    } #$i


        # 追加用GACCon.....に書き込む
        foreach my $key (keys %$gaccon){
            my $gacconjson = to_json(\@{$gaccon->{$key}});
         #   $redis->set("GACCon$key" => $gacconjson );
            $redis->hset("GACCon$key" , $gaccon->{$key}->[0]->{email}, $gacconjson );
            $redis->expire("GACCon$key" => 12 );
	    #  $self->app->log->info("DEBUG: add gaccon: $key | $gacconjson ");
            $job->app->log->info("DEBUG: add gaccon: $key | $gaccon->{$key}->[0]->{email} | $gacconjson ");
        }

  undef @proclist;
  undef @coprolist;
  undef @coprocount;
  undef $pcountchk;
  undef $gaccon;
});  # add_task


    $self->app->minion->enqueue(gaccput => [$gcount, $lat, $lng, $redisserver, $gacclist, $host  ] );
    $self->app->log->info("DEBUG: gcount: $gcount  lat: $lat lng: $lng redisserver: $redisserver gacclist: $gacclist host: $host");
    #  $self->app->minion->perform_jobs;  # temporary worker need

}

1;
