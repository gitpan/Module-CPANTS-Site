package Module::CPANTS::Site::C::Kwalitee;

use strict;
use base 'Catalyst::Base';


sub view : Regex('^kwalitee$') {
    my ($self,$c,$kwid) = @_;
    $c->stash->{template} = 'kwalitee/view';
    
    if ($kwid =~ /^\d+$/) {
        $c->stash->{item}=Module::CPANTS::DB::Kwalitee->retrieve($kwid);
    } else {
        my @l=Module::CPANTS::DB::Dist->retrieve_dist($kwid);
        $c->log->info("search dist $kwid @l");
        if (@l == 1) {
            $c->stash->{item}=$l[0]->kwalitee;
        } else {
            $c->res->redirect('/dist/search?dist='.$kwid);
        }
    }
}

sub shortcoming : Local {
    my ($self,$c) = @_;
    my $sc=$c->param('name');
    return $c->res->redirect('/kwalitee.html') unless $sc;

    my ($ind)=grep {$_->{name} eq $sc } @{$c->cpants_indicators};
    $c->stash->{indicator}=$ind;
    $c->stash->{template} = 'kwalitee/shortcoming';
}

=head1 NAME

Module::CPANTS::Site::C::Kwalitee - Catalyst component

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
