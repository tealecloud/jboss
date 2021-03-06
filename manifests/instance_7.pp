# Creates, configures and set up the service for a JBoss-7.1.1.Final instance,
# i.e. a server profile with all the
# configurations needed to use it as an independent service.
# *Note*: at this time the instance is created as a standalone standard profile.
#
# Declares all other classes in the jboss module needed for installing a jboss
# server profile.
# Currently, these consists of jboss::instance::install,
# jboss::instance::config, and jboss::instance::service.
#
# Requires:
#
# * Class['jboss'] for installing and setting up basic jboss environment.
# * Class['java::java_7'] for installing and setting up java7-jdk.
#
# @param instance_name Name of the JBoss profile and associated service
#                   corresponding to this instance.
#                   Defaults to the resource title.
#
# @param ip Dedicated IP on which this instance will be listening.
#                   Defaults to <tt>127.0.0.1</tt> i.e. localhost.
#
# @param iface Name of the secondary network interface dedicated to this
#                   instance.
#                   Defaults to +undef+, in which case a secondary network
#                   interface to bind the jboss instance is not created.
#
# @param environment Abbreviation identifying the environment: valid values are
#                   +dev+, +test+, +prep+, +prod+.
#                   Defaults to +dev+.
#                   *Note:* hot code deployment is disabled in the environments
#                   +prep+ and +prod+, enabled on +dev+ and +test+.
#
# @param distribution_name Name of the distribution bundle to download, used for
#                      installing customed distributions.
#                      Defaults to <tt>jboss-as-7.1.1.Final.zip</tt>
#
# @param jbossdirname Name of the jboss installation folder.
#                   Defaults to +jboss-as-7.1.1.Final+
#
# @param xms JVM OPT for initial heap size.
#                   Defaults to +128m+.
#
# @param xmx JVM OPT for maximum heap size.
#                   Defaults to +512m+.
#
# @param max_perm_size JVM OPT for max permanent generations size.
#                   Defaults to +256m+.
#
# @param stack_size JVM OPT for stack size.
#                   Defaults to +2048k+.
#
# @param mgmt_user Management user username.
#                   Defaults to +undef+, in which case a management user is not
#                   created.
#
# @param mgmt_passwd Management user password.
#                   Defaults to +undef+.
#
# @param jmx_user JMX user username.
#                   Defaults to +undef+, in which case a management user is not
#                   created.
#
# @param jmx_passwd JMX user password.
#                   Defaults to +undef+.
#
# @param backup_conf_target Full pathname of the backup configuration file where the
#                       instance paths
#                       to backup are added.
#                       Defaults to <tt>/usr/local/bin/backupall.sh.conf</tt>.
#
# @example Declaring jboss 7 instance
#  jboss::instance_7 { 'fina':
#    environment => 'preprod',
#    ip          => '172.16.12.11',
#    iface       => 'eth0:2',
#    jmxport     => '12345',
#  }
#
# @author Dario Sestero
define jboss::instance_7 (
  $instance_name      = $title,
  $ip                 = '127.0.0.1',
  $iface              = undef,
  $environment        = 'dev',
  $distribution_name  = 'jboss-as-7.1.1.Final.zip',
  $jbossdirname       = 'jboss-as-7.1.1.Final',
  $xms                = '128m',
  $xmx                = '512m',
  $max_perm_size      = '256m',
  $stack_size         = '2048k',
  $mgmt_user          = undef,
  $mgmt_passwd        = undef,
  $jmx_user           = undef,
  $jmx_passwd         = undef,
  $backup_conf_target = '/usr/local/bin/backupall.sh.conf',) {
  require jboss::params

  jboss::instance_7::install { $instance_name:
    distribution_name  => $distribution_name,
    environment        => $environment,
    jbossdirname       => $jbossdirname,
    backup_conf_target => $backup_conf_target,
  } ->
  jboss::instance_7::config { $instance_name:
    ip            => $ip,
    iface         => $iface,
    environment   => $environment,
    jbossdirname  => $jbossdirname,
    xms           => $xms,
    xmx           => $xmx,
    max_perm_size => $max_perm_size,
    stack_size    => $stack_size,
    mgmt_user     => $mgmt_user,
    mgmt_passwd   => $mgmt_passwd,
    jmx_user      => $jmx_user,
    jmx_passwd    => $jmx_passwd,
    java_home     => $jboss::params::java7_home,
  } ~>
  jboss::instance::service { $instance_name:
    environment => $environment,
  } ->
  jboss::instance_7::postconfig { $instance_name:
    ip           => $ip,
    iface        => $iface,
    environment  => $environment,
    jbossdirname => $jbossdirname,
    mgmt_user    => $mgmt_user,
    mgmt_passwd  => $mgmt_passwd,
  }
}