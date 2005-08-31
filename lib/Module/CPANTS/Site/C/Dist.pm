package Module::CPANTS::Site::C::Dist;

use strict;
use base 'Catalyst::Base';
use Module::CPANTS::DB;

sub search : Local {
    my ($self,$c) = @_;
    $c->stash->{template} = 'dist/search';

    if (my $term=$c->param('dist')) {
        $term=~s/::/-/g;
        my $pager=Module::CPANTS::DB::Dist->pager(40,$c->param('page') || 1);
        my $list=$pager->search_like(dist_without_version=>'%'.$term.'%',{order_by=>'dist'});
        $c->stash->{list}=$list;
        $c->stash->{pager}=$pager;
    }
}


sub view : Regex('^dist$') {
    my ($self,$c,$distname) = @_;
    
    return $c->forward('/dist/search') unless $distname;
    
    my ($distname,$distname_colons)=$c->distname($distname);

    my @dist=Module::CPANTS::DB::Dist->retrieve_dist($distname);
    if (@dist == 1) {
        $c->stash->{dist}=$dist[0];
    } else {
        my @mod=Module::CPANTS::DB::Modules->search(module=>$distname_colons);
        if (@mod == 1) {
            return $c->res->redirect("/dist/".$mod[0]->dist->dist_without_version);
        }
        return $c->res->redirect('/dist/search?dist='.$distname);
    }

    my @req=Module::CPANTS::DB::Dist->search_required_by($dist[0]->id);
    $c->stash->{req}=\@req if @req;
    $c->stash->{template} = 'dist/view';
}

# TODO: pager, error handling
sub shortcoming : Local {
    my ($self,$c) = @_;
    my $sc=$c->param('metric');
    my $DBH=Module::CPANTS::DB->db_Main;
    my $sth;
    eval {
        $sth=$DBH->prepare(
            "SELECT dist.id from dist,kwalitee
            WHERE dist.kwalitee=kwalitee.id AND kwalitee.".$sc."=0
            order by dist.dist");
        $sth->execute
    };
    $c->log->info($@) if $@;
    my $pager=Module::CPANTS::DB::Dist->pager(40,$c->param('page') || 1);
    my $list=$pager->sth_to_objects($sth);
    $c->stash->{list}=$list;
    $c->stash->{pager}=$pager;

    $c->stash->{template} = 'dist/shortcoming';
}


=head1 NAME

Module::CPANTS::Site::C::Dist - Catalyst component

=head1 SYNOPSIS

See L<Module::CPANTS::Site>

=head1 DESCRIPTION

Catalyst component.

=head1 METHODS

=over 4

=item default


=head1 AUTHOR

domm,,,

=head1 LICENSE

This library is free software . You can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
