package Ghostman::Controller::Ghostman;
use Mojo::Base 'Mojolicious::Controller';

# morboを前提で作成されているサーバ hypnotoadを１workerで動作させる

use Proc::ProcessTable;
use Mojo::JSON qw(encode_json decode_json from_json to_json);
use Mojo::UserAgent;

# 独自パスを指定して自前モジュールを利用
use lib '/home/debian/perlwork/mojowork/server/ghostman/lib/Ghostman/Model';
use Pcountchk;
use Roundget;

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
#                   "10.140.0.2:3010",
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
           $self->app->log->info("DEBUG: host check: $host DROPed.....");
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
             $self->app->log->info("DEBUG: pcount(true): $res_j" );
         } else {
             #retry
             my $ret = $instance->check;
             if ($ret == 0){
                 my $res = $instance->resilt;
                 my $res_j = to_json($res);
                 push (@pcountres, $res);
                 $self->app->log->info("DEBUG: pcount2(true): $res_j" );
             } else {
                 my $res = $instance->result;
                 my $res_j = to_json($res);    # 空白80個で強制的にdropさせる
                 my $dumdata = {"acclist" => ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""] };
                 push (@pcountres, $dumdata);
                 $self->app->log->info("DEBUG: pcount2(error): $res_j" );
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

           $self->app->log->info("DEBUG: acclist $j | count: $#ii ");

           # 上限に達しているサーバをリストする
           if ( $#ii >= ($proclimit -1) ) {
              push (@drophost, $hostlist[$j]); 
              $self->app->log->info("DROP hostlist: $hostlist[$j] ");
              }
    } # for

    $self->app->log->info("DEBUG: allprocs: $allprocs ");

    my $limitcount = $proclimit * ($#hosts + 1 );

    $self->app->log->info("DEBUG: limitcount: $limitcount ");

    if ( $limitcount < $allprocs) {
           $self->app->log->info("allprocs: $allprocs  NOT EXEC NPC.........");
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
                                              $self->app->log->info("DEBUG: $i->{email} EXIST");
                                              }
                } #for
             } #if npcuser

            if ($j =~ /searchnpc/ ){
              for my $i (@$sglist){
                  if ( $j eq $i->{email}) {
                                              $i->{run} = "exist";
                                              $self->app->log->info("DEBUG: $i->{email} EXIST");
                                              }
                } #for
              } # if $j
          } #foreach @haccs
      } #foreach @hosts

      my $debugvar = to_json($hostprocs);
      $self->app->log->info("DEBUG: hostprocs: $debugvar");
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


1;
