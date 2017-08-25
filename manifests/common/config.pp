# Private class
class slurm::common::config {

  create_resources('slurm::spank', $slurm::spank_plugins)

  if $slurm::manage_slurm_conf {
<<<<<<< HEAD
    file { 'slurm.conf':
      ensure  => 'present',
      path    => $slurm::slurm_conf_path,
      content => $slurm::slurm_conf_content,
      source  => $slurm::_slurm_conf_source,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { 'slurm-partitions.conf':
      ensure  => 'present',
      path    => $slurm::partition_conf_path,
      content => $slurm::partitionlist_content,
      source  => $slurm::_partitionlist_source,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    if $slurm::_node_source {
      file { 'slurm-nodes.conf':
        ensure => 'present',
        path   => $slurm::node_conf_path,
        source => $slurm::_node_source,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
    } else {
      datacat { 'slurm-nodes.conf':
        ensure   => 'present',
        path     => $slurm::node_conf_path,
        template => 'slurm/slurm.conf/nodes.conf.erb',
        owner    => 'root',
        group    => 'root',
        mode     => '0644',
      }
=======

    if $slurm::manage_slurm_conf_nfs_mount {

      if !$slurm::controller {
        file { 'SlurmConfNFSMountPoint':
          ensure  => 'directory',
          path    => $slurm::slurm_conf_nfs_location,
        }

        mount { 'SlurmConfNFSMount':
          ensure  => 'mounted',
          name    => $slurm::slurm_conf_nfs_location,
          atboot  => true,
          device  => $slurm::slurm_conf_nfs_device,
          fstype  => 'nfs',
          options => $slurm::slurm_conf_nfs_options,
          require => File['SlurmConfNFSMountPoint'],
        }
>>>>>>> c27add9aa2f827d030815598b6eb2099887daef8

        file { 'slurm.conf':
          ensure  => 'link',
          path    => $slurm::slurm_conf_path,
          target  => "${slurm::slurm_conf_nfs_location}/slurm.conf",
          require => Mount['SlurmConfNFSMount'],
        }

        file { 'slurm-partitions.conf':
          ensure  => 'link',
          path    => $slurm::partition_conf_path,
          target  => "${slurm::slurm_conf_nfs_location}/partitions.conf",
          require => Mount['SlurmConfNFSMount'],
        }

        file { 'Link slurm-nodes.conf':
          ensure => 'link',
          path   => $slurm::node_conf_path,
          target => "${slurm::slurm_conf_nfs_location}/nodes.conf",
          require => Mount['SlurmConfNFSMount'],
        }
      }
    }

    file { 'plugstack.conf.d':
      ensure  => 'directory',
      path    => $slurm::plugstack_conf_d_path,
      recurse => true,
      purge   => $slurm::purge_plugstack_conf_d,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { 'plugstack.conf':
      ensure  => 'file',
      path    => $slurm::plugstack_conf_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('slurm/spank/plugstack.conf.erb'),
    }

    file { 'slurm-cgroup.conf':
      ensure  => 'file',
      path    => $slurm::cgroup_conf_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $slurm::cgroup_conf_content,
      source  => $slurm::_cgroup_conf_source,
    }

    file { 'cgroup_allowed_devices_file.conf':
      ensure  => 'file',
      path    => $slurm::cgroup_allowed_devices_file_real,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($slurm::cgroup_allowed_devices_template),
    }
  }

  sysctl { 'net.core.somaxconn':
    ensure => present,
    val    => '1024',
  }

}
