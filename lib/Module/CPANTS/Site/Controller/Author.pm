package Module::CPANTS::Site::Controller::Author;

use strict;
use warnings;
use base 'Catalyst::Controller';


sub search : Local {
    my ($self,$c) = @_;
    $c->stash->{template} = 'author/search';

    if (my $term=$c->req->param('pauseid')) {
        $c->stash->{list}=$c->model('DBIC::Author')->search_like(
            {
                pauseid=>uc($term).'%',
            },
            {
                order_by=>'pauseid ASC',
                page=>$c->request->param('page') || 1,
                rows=>20,
            });
    }
}

sub view : Regex('^author$') {
    my ($self,$c,$author) = @_;
    $c->stash->{template} = 'author/view';
    
    return $c->forward('/author/search') unless $author;
    
    my $a=$c->model('DBIC::Author')->search({pauseid=>$author});
    
    $c->stash->{item}=$a->next;
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
