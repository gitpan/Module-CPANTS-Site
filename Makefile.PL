use inc::Module::Install;

name 'Module-CPANTS-Site';
all_from 'lib/Module/CPANTS/Site.pm';

requires Catalyst => '5.64';
requires Module::CPANTS::Analyse => '0.60';
requires Module::CPANTS::ProcessCPAN => '0.60';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
