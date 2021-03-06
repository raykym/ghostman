#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

# >gaccputworker.pl minion worker
# ghostman gaccputのロジックをそのままworkerにしたもの


use Minion;
use Mojo::Pg;

my $minion = Minion->new(Pg => 'postgresql://minion:minionpass@localhost/minion');

$minion->add_task(gaccput => sub {
  my ($job, @args) = @_;

        my ( $gcount, $lat, $lng, $redisserver, $gacclist, $host  ) = @args;   # 引数を展開

	$| = 1;  # buffer off
	my $mongoserver = "10.140.0.4";

	use Mojo::JSON qw(from_json to_json);
        use Mojo::Redis2;
        use Mojo::UserAgent;
        use DateTime;
        use Encode qw(encode_utf8 decode_utf8);
	use MongoDB;

        use lib '/home/debian/perlwork/mojowork/server/ghostman/lib/Ghostman/Model';
        use Pcountchk;
        use Sessionid;


my $mongoclient = MongoDB->connect("mongodb://$mongoserver:27017");
my $wwlogdb = $mongoclient->get_database('WalkWorldLOG');
our $npcuserlog = $wwlogdb->get_collection('npcuserlog');  # Logingでは無記名sub内のサブルーチン、でスコープが外れるので、公開指定をする

# 表示用ログフォーマット
sub Loging {
    my $logline = shift;
    my $dt = DateTime->now();
       $logline = encode_utf8($logline);
    say "$dt | $logline";
    $logline = decode_utf8($logline);
    my $dblog = { 'ttl' => $dt, 'logline' => $logline, 'email' => "worker" };    # ログ切り分け用にemailを設定
       $npcuserlog->insert_one($dblog);

    undef $logline;
    undef $dt;
    undef $dblog;

    return;
}


        my $redis ||= Mojo::Redis2->new(url => "redis://$redisserver:6379");
        my $ua = Mojo::UserAgent->new;

        my $pcountchk = Pcountchk->new($host);     # AnyEvent::Condvarでエラーが起きる。　10回で終了　abort配列が戻る想定　初回は正常終了で空がある
           $pcountchk->gacccheck;
        my $res = $pcountchk->result; # $res->{proclist}に配列でsidが入っている
        my @proclist = @{$res->{proclist}};

	Loging("@proclist");

        # 実行中アカウントのチェック gacclistにrun=existをチェックする
        my @coprolist = ();   # 実行中のアカウント情報の配列の配列 proclistに位置が同じはず配列だから
        my @coprocount = ();  # @coprolistに合わせてカウントす

	if ($proclist[0] eq "abort" ){
            Loging("DEBUG: Pcountchk abort END!!!");
            return;
	}

        Loging("START worker");

        if ($#proclist != -1 ){  # 空配列ならパス
            for my $i (@proclist){
                my $pacclist;
                   $pacclist = $redis->get("GACC$i");
                   $pacclist = from_json($pacclist) if ( defined $pacclist);

		my $pacclist_on;
                   $pacclist_on = $redis->hvals("GACCon$i");   # 配列にテキストが入っている

		   for my $j (@$pacclist_on){
		       my $pacclist_one;
                       $pacclist_one = from_json($j) if ( defined $j);
                       if ( defined $pacclist_one ){
                           push(@$pacclist,@$pacclist_one);   # 連想配列に連想配列をつなげる
			   Loging("already add pacclist: $j");
		       } 
		       undef $pacclist_one;
    	           } # for $j

                push(@coprolist,$pacclist) if ( defined $pacclist); #実行中アカウント情報の配列を取得 GACConもとりあえず追加する
                undef $pacclist;
		undef $pacclist_on;

         } # for @proclist

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
		      #   $job->app->log->info("DEBUG check: $j->{name} $j->{run}");
		      #   Loging("check: $j->{name} $j->{run}");
                     }
                 } #j
         }#i
	 #  $job->app->log->info("DEBUG: Check END!!");
	       Loging("Check END!!");
         }  else {   # if @proclist ここまでバイパスする
		 #   $job->app->log->info("DEBUG: @proclist is null!");
	       Loging('@proclist is null!');
         }

         my $sid;

         if (!@proclist){
             #子プロセスが無いので準備する。
             $sid = Sessionid->new->sid;
             $ua->post("http://$host/gaccexecminion" => form => { sid => $sid });   # Roundgetでラウンドロビンに振り分けられる
	     #   $job->app->log->info("DEBUG: procexec: $sid");
	     Loging(" procexec: $sid");
             push(@proclist,$sid);
             push(@coprolist,[]);
             push(@coprocount,0);
         }

         # 子プロセスに受け入れる容量が在るのか？確認するには
	 my @chkarray;
         for my $i (@coprocount){
             if ( $i >= 99 ) {
                 push(@chkarray,1); 
	     }
         }

         # coprolistの配列数とchkarrayが一致したら追加で作成
         if ( $#chkarray >= $#coprolist ) {
		 
             # 1サーバ当たり5プロセスを上限とする。  もう一度要求が来れば、別のサーバを指定されることで追加されるはず。
             if ($#proclist > 5){ # 5プロセスでリミットを設定しておく 6個まで動くがそうしないと止まってしまう　スケールアウトでラウンドロビンさせる
                 #  $self->res->headers->header("Access-Control-Allow-Origin" => 'https://westwind.backbone.site' );
                 #  $self->render(msg => 'this server limit over');
	         Loging("this server limit over");
                 return;
             }

             #子プロセスの空きが要求個数に満たない場合、子プロセスを追加
             $sid = Sessionid->new->sid;
             $ua->post("http://$host/gaccexecminion" => form => { sid => $sid });
	     #  $job->app->log->info("DEBUG: 2 procexec: $sid");
	     Loging(" 2 proxexec: $sid");
             push(@proclist,$sid);
             push(@coprolist,[]);
             push(@coprocount,0);
         }
	 undef @chkarray;

         my $gaccon = {};

         for (my $i=0; $i<$gcount; $i++){
             for (my $j=0; $j<=$#coprolist; $j++) {
		     #   $job->app->log->info("DEBUG: coprocount: $coprocount[$j]");
                         Loging("DEBUG: coprocount: $coprocount[$j]");
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
		      #  $job->app->log->info("DEBUG: gacc: ADD: $kjson");
		      Loging("gacc: ADD: $kjson");
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
            $redis->hset("GACCon$key" , $gaccon->{$key}->[0]->{email}, $gacconjson );
            $redis->expire("GACCon$key" => 12 );
	
	 #   $job->app->log->info("DEBUG: add gaccon: $key | $gacconjson ");
           Loging("add gaccon: $key | $gaccon->{$key}->[0]->{email} | $gacconjson");

    }  # foreach key

    undef @proclist;
    undef @coprolist;
    undef @coprocount;
    undef $pcountchk;
    undef $gaccon;

    Loging("worker process END!!");
    #  my $error = $job->execute;
    #Loging("worker error: $error") if ( defined $error );

});


     $minion->add_task( gaccexec => sub {
                     my ($job, @args ) = @_;
                     my $sid = $args[0];

                     system("/home/debian/perlwork/work/Walkworld/npcuser_n_sitedb_w.pl $sid > /dev/null 2>&1 & ");  # westwind

                     say "GACCEXEC: process exec $sid";
                     Loging("GACCEXEC: process exec $sid");
     });


my $worker = $minion->worker;
$worker->status->{jobs} = 1;
$worker->run;


