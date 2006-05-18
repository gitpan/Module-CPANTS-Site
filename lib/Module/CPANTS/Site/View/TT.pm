package Module::CPANTS::Site::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
        WRAPPER=>'wrapper',
        INCLUDE_PATH=>Module::CPANTS::Site->config->{home}.'/templates',
});

=head1 NAME

Module::CPANTS::Site::View::TT - TT View Component

=head1 SYNOPSIS

See L<Module::CPANTS::Site>

=head1 DESCRIPTION

TT View Component.

=head1 AUTHOR

domm,,,

=head1 LICENSE

This library is free software . You can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
