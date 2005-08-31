package Module::CPANTS::Site::C::Author;

use strict;
use base 'Catalyst::Base';


sub search : Local {
    my ($self,$c) = @_;
    $c->stash->{template} = 'author/search';

    if (my $term=$c->param('pauseid')) {
        my $pager=Module::CPANTS::DB::Author->pager(40,$c->param('page') || 1);
        my $list=$pager->search_like(pauseid=>$term.'%',{order_by=>'pauseid'});
        $c->stash->{list}=$list;
        $c->stash->{pager}=$pager;
    }
}

sub view : Regex('^author$') {
    my ($self,$c,$author) = @_;
    $c->stash->{template} = 'author/view';
    
    return $c->forward('/author/search') unless $author;
    
    my @author=Module::CPANTS::DB::Author->retrieve_author($author);
    my $a=$author[0];
    
    $c->not_found unless $a;
    
    $c->res->status(404) unless $a;
    $c->stash->{item}=$a;
}


=head1 NAME

Module::CPANTS::Site::C::Author - Catalyst component

=head1 SYNOPSIS

See L<Module::CPANTS::Site>

=head1 DESCRIPTION

Catalyst component.

=head1 METHODS

=over 4

=item default

=cut

=head1 AUTHOR

domm,,,

=head1 LICENSE

This library is free software . You can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
