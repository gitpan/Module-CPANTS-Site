package Module::CPANTS::Site;

use strict;
use Catalyst qw/-Debug Static/;

use lib '/home/domm/perl/Module-CPANTS-Generator/lib';
use Module::CPANTS::Generator;

our $VERSION = '0.04';

Module::CPANTS::Site->config(
    name=>'CPANTS',
);

Module::CPANTS::Site->setup;

foreach (qw(cpants_schema c_cpants_indicators c_cpants_indicators_hash)) {
    __PACKAGE__->mk_classdata($_);
}

sub i : Global {
    my ($self,$c)=@_;
    $c->serve_static; # from Catalyst::Plugin::Static
}

sub begin : Private {
    my ($self,$c)=@_;
    my $ind=$self->cpants_indicators;
    my $ind_h=$self->cpants_indicators_hash;
    $c->stash->{kwalitee}=$ind;
    $c->stash->{kwalitee_hash}=$ind_h;
    $c->stash->{total}=scalar @$ind;

    $c->stash->{run_date}=$self->run_date;
}

#----------------------------------------------------------------
# pseudo-static pages
#----------------------------------------------------------------
sub pseudostatic : Regex('^(\w+).html') {
    my ($self,$c) = @_;
    my $file=$c->req->snippets->[0];
    $c->stash->{template} = "static/$file";
}

sub disabled : Path('/disabled.html') {
    my ($self,$c) = @_;
    $c->stash->{template} = "static/disabled";
}

sub dbschema : Path('/db_schema.html') {
    my ($self,$c) = @_;
    
    my $schema=$self->cpants_schema;
    unless ($schema) {
        my $cp=Module::CPANTS::Generator->new;
        $schema=$cp->get_schema_text;
        $self->cpants_schema($schema);
    }
    $c->stash->{schema}=$schema;
    $c->stash->{template} = "static/db_schema";
}

sub kwalitee : Path('/kwalitee.html') {
    my ($self,$c) = @_;
    $c->stash->{template} = "static/kwalitee";
}

sub highscores : Path('/highscores.html') {
    my ($self,$c)=@_;
  
    my $highest=$c->highest_kwalitee;    
    $c->stash->{best_dists}=Module::CPANTS::DB::Dist->search_best_dists($highest);
    $c->stash->{worst_dists}=Module::CPANTS::DB::Dist->search_worst_dists;
    $c->stash->{template} = "static/highscores";
}

sub hall_of_fame : Path('hall_of_fame.html') {
    my ($self,$c)=@_;

    $c->stash->{title}="Hall of Fame";
    $c->stash->{best_dists}=Module::CPANTS::DB::Dist->search_best_dists($c->highest_kwalitee);
    $c->stash->{template} = "static/highscores";
}


#----------------------------------------------------------------
# default Catalyst stuff
#----------------------------------------------------------------
sub default : Private {
    my ( $self, $c ) = @_;
    $c->stash->{template} = "static/index";
}

sub end : Private {
    my ( $self, $c ) = @_;
    $c->stash->{VERSION}=$VERSION;
    $c->stash->{generator_version}=$Module::CPANTS::Generator::VERSION;
    $c->forward('Module::CPANTS::Site::V::TT') unless ( $c->res->body || !$c->stash->{template} );
}


#----------------------------------------------------------------
# helper stuff
#----------------------------------------------------------------
sub param {
    return shift->req->param(@_);
}

sub highest_kwalitee {
    my $dbh=Module::CPANTS::DB->db_Main;
    my $highest=$dbh->selectrow_array("select kwalitee from kwalitee order by kwalitee desc limit 1");
    return $highest;
}

sub distname {
    my ($self,$distname)=@_;
    my $distname_colons;
    if ($distname=~/::/) {
        $distname_colons=$distname;
        $distname=~s/::/-/g;
    } else {
        $distname_colons=$distname;
        $distname_colons=~s/-/::/g;
    }
    return ($distname,$distname_colons);
}   

sub cpants_indicators {
    my $self=shift;
    my $ind=$self->c_cpants_indicators;
    return $ind if $ind;
    
    my $cp=Module::CPANTS::Generator->new;
    $ind=$cp->get_indicators;
    $self->c_cpants_indicators($ind);
    return $ind;
}
sub cpants_indicators_hash {
    my $self=shift;
    my $ind=$self->c_cpants_indicators_hash;
    return $ind if $ind;
    
    my $cp=Module::CPANTS::Generator->new;
    $ind=$cp->get_indicators_hash;
    $self->c_cpants_indicators_hash($ind);
    return $ind;
}

my $run_date='';
sub run_date {
    my $self=shift;
    return $run_date if $run_date;
    my $dbh=Module::CPANTS::DB->db_Main;
    $run_date=$dbh->selectrow_array('select date from version');
    return $run_date;
}

=head1 NAME

Module::CPANTS::Site - Catalyst based application

=head1 SYNOPSIS

    script/module_cpants_site_server.pl

=head1 DESCRIPTION

Catalyst based application.

=head1 METHODS

=over 4

=item default

This is called if no other action matched

=over 4

=item end

Forward to TT view

=back

=head1 AUTHOR

Thomas Klausner, domm@zsi.at

=head1 LICENSE

This library is free software . You can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
