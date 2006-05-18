package Module::CPANTS::Site::Controller::Kwalitee;

use strict;
use warnings;
use base 'Catalyst::Controller';

sub shortcoming : Local {
    my ($self,$c) = @_;
    my $metric=$c->req->param('name');

    my $kw=Module::CPANTS::Site::Model::Kwalitee->kwalitee;
    
    $c->stash->{indicator}=$kw->get_indicators_hash->{$metric};
    $c->stash->{template}='kwalitee/shortcoming';
}



sub view : Regex('^kwalitee$') {
    my ($self,$c,$distname) = @_;
    
    my $dist=$c->model('DBIC::Dist')->search({dist=>$distname});
    if ($dist == 1) {
        $c->stash->{dist}=$dist->next;
    }
    $c->stash->{template} = 'kwalitee/view';
}


'listening to: kids during judo training';

__END__

=head1 NAME

Module::CPANTS::Site::Controller::Kwalitee - Catalyst Controller

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

1;
