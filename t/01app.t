use Test::More tests => 2;
use_ok( Catalyst::Test, 'Module::CPANTS::Site' );

ok( request('/')->is_success );
