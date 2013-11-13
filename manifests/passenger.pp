# Class: dashboard::passenger
#
# This class configures parameters for the puppet-dashboard module.
#
# Parameters:
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
  $dashboard_root,
  $rails_base_uri,
) inherits dashboard {

  require ::passenger
  include apache
  include firewall

  file { '/etc/init.d/puppet-dashboard':
    ensure => absent,
  }

  file { 'dashboard_config':
    ensure => absent,
    path   => $dashboard_config,
  }

  # this could be made a conditional, but the dashboard is
  # implicitly a public interface, so it seems OK to just
  # open the port...
  firewall { "${dashboard_port} accept - puppet dashboard":
    port   => $dashboard_port,
    proto  => 'tcp',
    state  => 'NEW',
    action => 'accept',
  }

  apache::vhost { $dashboard_site:
    port              => $dashboard_port,
    priority          => '50',
    docroot           => "${dashboard_root}/public",
    servername        => $dashboard_site,
    options           => 'None',
    override          => 'AuthConfig',
    error_log         => true,
    access_log        => true,
    access_log_format => 'combined',
    custom_fragment   => "RailsBaseURI ${rails_base_uri}",
  } 
}
