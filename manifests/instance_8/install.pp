# Install a JBoss-8 instance,
# i.e. a server profile. It is intended to be called by jboss::instance.
#
# @author Dario Sestero
define jboss::instance_8::install (
  $environment,
  $jbossdirname,
  $distribution_name,
  $backup_conf_target,
  $instance_name = $title,) {
  $jboss_inst_folder = "/opt/jboss-8-${instance_name}/${jbossdirname}"
  $ip_alias = "${instance_name}-${environment}"

  include java::java_7, jboss::instance::dependencies

  $require = [Class['jboss'], Class['jboss::jboss_8']]

  jboss::instance::install { $instance_name:
  }

  download_uncompress { "install_jboss_8_${instance_name}":
    distribution_name => $distribution_name,
    dest_folder       => "/opt/jboss-8-${instance_name}",
    creates           => "/opt/jboss-8-${instance_name}",
    uncompress        => 'tar.gz',
    user              => jboss,
    group             => jboss,
  }

  # backup configuration lines
  @@concat::fragment { "${ip_alias}-modules":
    target  => $backup_conf_target,
    content => "${jboss_inst_folder}/modules/system/layers/base\n",
    tag     => [$::environment, $facts['networking']['fqdn']],
  }

  @@concat::fragment { "${ip_alias}-standalone-configuration":
    target  => $backup_conf_target,
    content => "${jboss_inst_folder}/standalone/configuration\n",
    tag     => [$::environment, $facts['networking']['fqdn']],
  }

  @@concat::fragment { "${ip_alias}-standalone-deployments":
    target  => $backup_conf_target,
    content => "${jboss_inst_folder}/standalone/deployments\n",
    tag     => [$::environment, $facts['networking']['fqdn']],
  }

}