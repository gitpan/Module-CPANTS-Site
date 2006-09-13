package Module::CPANTS::Site;

use strict;
use warnings;
use Catalyst qw/ConfigLoader Static::Simple/;

our $VERSION = '0.62';

__PACKAGE__->setup;


sub default : Private {
    my ( $self, $c ) = @_;
    $c->stash->{template}='index';
}

sub kwalitee : Path('kwalitee.html') {
    my ( $self, $c ) = @_;
    $c->stash->{template}='static/kwalitee';
}
sub graphs : Path('graphs.html') {
    my ( $self, $c ) = @_;
    $c->stash->{template}='static/graphs';
}

sub news : Path('news.html') {
    my ( $self, $c ) = @_;
    $c->stash->{template}='static/news';
}

sub end : Private {
    my ( $self, $c ) = @_;

    $c->stash->{VERSION}=$VERSION;
    my $kw=Module::CPANTS::Site::Model::Kwalitee->kwalitee;
    my $rs=$c->model('DBIC::Run')->search({},
        {
            order_by=>'date desc',
            rows=>1,
        });
    $c->stash->{run}=$rs->first;
    $c->stash->{mck}=$kw;
    $c->forward( $c->view('') ) unless $c->stash->{'is_redirect'} || $c->response->body;
}

sub max_kwalitee {
    my ($c)  = @_;
    my $rs=$c->model('DBIC::Kwalitee')->search(
        {},
        {
            select=>[{ max => 'kwalitee'}],
            as=>[qw(kwalitee)],
        }
    );
    return $rs->first->kwalitee;
}


'listening to: Nightmares on Wax - in a space outta sound';

__END__

=head1 NAME

Module::CPANTS::Site - Catalyst based application

=head1 SYNOPSIS

    script/module_cpants_site_server.pl

=head1 DESCRIPTION

Catalyst based application.

=head1 METHODS

=head2 default

#
# Output a friendly welcome message
#
sub default : Private {
    my ( $self, $c ) = @_;

    # Hello World
    $c->response->body( $c->welcome_message );
}

#
# Uncomment and modify this end action after adding a View component
#
#=head2 end
#
#=cut
#
#sub end : Private {
#    my ( $self, $c ) = @_;
#
#    # Forward to View unless response body is already defined
#    $c->forward( $c->view('') ) unless $c->response->body;
#}

=head1 AUTHOR

domm,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
