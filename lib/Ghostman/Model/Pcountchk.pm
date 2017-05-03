package Pcountchk;

use strict;
use warnings;
use utf8;
use Encode;
use Mojo::UserAgent;
use Mojo::JSON qw(to_json from_json);
use EV;
use AnyEvent;

# ホスト名かIPアドレスを引数で受けて、ghostmanのpcountからリストを受け取る
# リトライ、タイムアウトへの対処
# ghostmanをmorbo ./script/ghostman -l http://10.140.0.2:3010で起動。ローカルアクセスを想定した形式を想定
# 受付用ghostmanはhypnotoadでSSL対応が必要だが、システム的にlocalhostで処理を回したい

# Pcountchk->new("10.140.0.2:3010")
sub new {
  # Pcountchk->new(host)
  my ($class,$arg,$flag,@result) = @_;
  return bless {string => $arg,flag => $flag,result => \@result},$class;
}

# ghostmang用
sub check {
  my $self = shift;
  # $self->{strings}にアドレスが入っている
  my $host = $self->{string};

  my $ua = Mojo::UserAgent->new; 
  my $tx = $ua->get("http://$host/pcount");   # local対応想定なのでhttpで。。。

  if (my $resp = $tx->success) {
          $self->{flag} = "true";
          $self->{result} = from_json($resp->body);
          return 0;
     }
   else {
      my $err = $tx->error;
         $self->{flag} = "false";
    #  die "$err->{code} responce: $err->{message}" if $err->{code};
    #  die "Connection error: $err->{message}";
         return 1;
   } # if 

} #check

# gacclist用
sub gacccheck {
  my $self = shift;
  # $self->{strings}にアドレスが入っている
  my $host = $self->{string};

  my $ua = Mojo::UserAgent->new; 
  my $tx = $ua->get("http://$host/gaccpcount");   # local対応想定なのでhttpで。。。

  if (my $resp = $tx->success) {
          $self->{flag} = "true";
          $self->{result} = from_json($resp->body);
          return 0;
     }
   else {
      my $err = $tx->error;
         $self->{flag} = "false";
         $self->{result} = [];
    #  die "$err->{code} responce: $err->{message}" if $err->{code};
    #  die "Connection error: $err->{message}";
         return 1;
   } # if 

} #gacccheck

sub result {
 my $self = shift;
   # 応答待ち処理を加える
   # hashまたは空リファレンス
   # 戻りはperl形式

   my $cv = AnyEvent->condvar;

   my $t = AnyEvent->timer(
    after => 0,
    interval => 1,
    cb => sub {
         if ($self->{flag} eq "true"){ 
              $cv->send;
          } elsif ($self->{flag} eq "false"){
              $cv->send; 
          }
        }
    );
    $cv->recv;
    return $self->{result};
}

sub flag {
  my $self = shift;
     # true or false...

  return $self->{flag};
}

sub string {
  my $self = shift;

  return $self->{string};
}

1;
