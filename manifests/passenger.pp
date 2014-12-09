# Class: dashboard::passenger
#
# This class configures parameters for the puppet-dashboard module.
#
# Parameters:
#   [*passenger_install*]
#     - Install passenger using puppetlabs/passenger module or assume it is 
#       installed by 3rd party 
#   [*dashboard_site*]
#     - The ServerName setting for Apache
#
#   [*dashboard_port*]
#     - The port on which puppet-dashboard should run
#
#   [*dashboard_config*]
#     - The Dashboard configuration file
#
#   [*dashboard_root*]
#     - The path to the Puppet Dashboard library
#
#   [*rails_base_uri*]
#     - The base URI for the application
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dashboard::passenger (
  $dashboard_site,
  $dashboard_port,
  $dashboard_config,
  $dashboard_root
) inherits dashboard {

  include apache
  include passenger

  file { '/etc/init.d/puppet-dashboard':
    ensure => absent,
  }

  file { 'dashboard_config':
    ensure => absent,
    path   => $dashboard_config,
  }

  apache::vhost { $dashboard_site:
    port              => $dashboard_port,
    priority          => '50',
    docroot           => "${dashboard_root}/public",
  }

}
