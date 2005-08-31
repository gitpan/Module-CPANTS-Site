package Module::CPANTS::Site::C::Highscores;

use strict;
use base 'Catalyst::Base';


sub hall_of_fame : Local {
    my ($self,$c)=@_;

    $c->stash->{title}="Hall of Fame";
    $c->stash->{list}=Module::CPANTS::DB::Dist->search_best_dists($c->highest_kwalitee);
    $c->stash->{template} = "highscores/distlist";
}

sub hall_of_shame : Local {
    my ($self,$c)=@_;

    $c->stash->{title}="Hall of Shame";
    $c->stash->{list}=Module::CPANTS::DB::Dist->search_worst_dists;
    $c->stash->{template} = "highscores/distlist";
}

sub many : Local {
    my ($self,$c)=@_;
    my $pager=Module::CPANTS::DB::Author->pager(100,$c->param('page') || 1);
    $c->stash->{list}=$pager->top40_many;
    $c->stash->{pager}=$pager;
    $c->stash->{top40type}="many";
    $c->stash->{template} = "highscores/top40"
}

sub few : Local {
    my ($self,$c)=@_;
    my $pager=Module::CPANTS::DB::Author->pager(100,$c->param('page') || 1);
    
    $c->stash->{list}=$pager->top40_few;
    $c->stash->{pager}=$pager;
    $c->stash->{top40type}="few";
    $c->stash->{template} = "highscores/top40"
}

sub default : Private {
   my ( $self, $c ) = @_;
   $c->stash->{template} = "highscores/index";
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
