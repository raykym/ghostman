package Ghostman::Controller::Top;
use Mojo::Base 'Mojolicious::Controller';

sub unknown {
    my $self = shift;
    # 未定義ページヘのアクセス
    $self->render(text => 'unknown page!!!', status => '404');
}

1;
