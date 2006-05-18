package Module::CPANTS::Site::Model::DBIC;
use strict;
use warnings;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Module::CPANTS::DB',
    connect_info => [
        'dbi:Pg:dbname=cpants',
	$Module::CPANTS::Site::USER,
	$Module::CPANTS::Site::PWD,
],
);


