use strict;
use warnings;

use Test::More tests => 3;
use_ok( 'Catalyst::Test', 'Module::CPANTS::Site' );
use_ok('Module::CPANTS::Site::Controller::Kwalitee');

ok( request('kwalitee')->is_success, 'Request should succeed' );

