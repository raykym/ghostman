package Gacclistobj;

use strict;
use warnings;
use utf8;

use lib '/home/debian/perlwork/mojowork/server/ghostman/lib/Ghostman/Model';
use Sessionid;

# gacclistを共通化するためにオブジェクト化: ->結局worker毎に設定されるので共通化できなかった
# ハッシュでリストを受けて、useridを設定して、ハッシュを返す

# Gacclistobj->new($list)
sub new {
  my ($class,$arg,$result) = @_;

# makelistの処理を一気にコンストラクタで行う
  my $gacclist = $arg;

  # useridを割り振る
    foreach my $acc (@$gacclist){
          if ($acc->{userid} eq ""){
              $acc->{userid} = Sessionid->new($acc->{email})->uid;
          #    $self->app->log->info("DEBUG: set $acc->{email}");
          } #if
    }

    $result = $gacclist;

  return bless {string => $arg, result => $result },$class;
}

sub makelist {
  my $self = shift;

  my $gacclist = $self->{string};

  # useridを割り振る
    foreach my $acc (@$gacclist){
          if ($acc->{userid} eq ""){
              $acc->{userid} = Sessionid->new($acc->{email})->uid;
          #    $self->app->log->info("DEBUG: set $acc->{email}");
          } #if
    }

  $self->{result} = $gacclist;

}

sub result {
    my $self = shift;
     # 配列のリファレンスを返す　テキストじゃない。

    return $self->{result};
}

sub string {
    my $self = shift;

    return $self->{string};
}

1;
