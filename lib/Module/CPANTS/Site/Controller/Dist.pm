package Module::CPANTS::Site::Controller::Dist;

use strict;
use warnings;
use base 'Catalyst::Controller';

sub search : Local {
    my ($self,$c) = @_;
    $c->stash->{template} = 'dist/search';

    if (my $term=$c->req->param('dist')) {
        $term=~s/::/-/g;
        
        # todo: ignore case in searches
        $c->stash->{list}=$c->model('DBIC::Dist')->search(
            {
                dist=>{'ilike'=>$term.'%'},
            },
            {
                order_by=>'dist ASC',
                page=>$c->request->param('page') || 1,
                rows=>20,
            });
    }
}


sub view : Regex('^dist$') {
    my ($self,$c,$distname) = @_;
    
    return $c->forward('/dist/search') unless $distname;

    my $dist;
    if ($distname=~/^\d+$/) {
        $dist=$c->model('DBIC::Dist')->find($distname);
    } else {
        $dist=$c->model('DBIC::Dist')->search({dist=>$distname});
        if ($dist == 1) {
            $dist=$dist->next 
        } else {
        # TODO
        #my @mod=Module::CPAN->search(module=>$distname_colons);
        #if (@mod == 1) {
        #    return $c->res->redirect("/dist/".$mod[0]->dist->dist_without_version);
        #}
            $c->forward('/dist/search?dist='.$distname);
        }
    }
    $c->stash->{dist}=$dist;
    $c->stash->{kwalitee_hash}=Module::CPANTS::Site::Model::Kwalitee->kwalitee->get_indicators_hash;
    $c->stash->{requiring}=$dist->search_related(
        'requiring',
        {},
        {
            order_by=>'dist.dist',
            prefetch=>[qw(dist)],
        }
    );
    $c->stash->{prereqs}=$dist->search_related(
        'prereq',
        {},
        {
            order_by=>'requires',
            # prefetch=>[qw(dist)],
        }
    );
    $c->stash->{template} = 'dist/view';
}

sub shortcoming : Local {
    my ($self,$c) = @_;
    my $sc=$c->req->param('metric');

    $c->stash->{list}=$c->model('DBIC::Dist')->search(
            {
                "kwalitee.$sc"=>0,
            },
            {
                join=>[qw(kwalitee)],
                order_by=>'dist',
                page=>$c->request->param('page') || 1,
                rows=>40,
            }
        );
            
    $c->stash->{template} = 'dist/shortcoming';
}


sub clean_distname {
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



'listening to: Nightmares on Wax - in a space outta sound';

__END__

=head1 NAME

Module::CPANTS::Site::Controller::Dist - Catalyst Controller

=head1 SYNOPSIS

See L<Module::CPANTS::Site>

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head1 AUTHOR

Thomas Klausner, <domm@cpan.org>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
