class pe_puppetenteprise::repoi(
  $pe_version = $pe_puppetenterprise::params::pe_version,
  $pe_url = $pe_puppetenterprise::params::pe_url,
  $pe_repodata = $pe_puppetenterprise::params::pe_repodata
) {
  include apache

  file{$pe_repodata:
    ensure => directory,
    owner  => "www-data",
    group  => "www-data",
    mode   => 0644,
  }

  exec{'download-pe':
    command => "curl -O $pe_url",
    cwd     => $pe_repodata,
    creates => "${pe_repodata}/puppet-enterprise-${pe_version}-all.tar.gz",
    require => File[$pe_repodata],
  }

  file{"${pe_repodata}/CentOS":
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => 0644,
    require => File[$pe_repodata],
  }

  file{"${pe_repodata}/CentOS/6/":
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => 0644,
    require => File["${pe_repodata}/CentOS"],
  }

  file{"${pe_repodata}/CentOS/6/puppetenterprise/x86_64":
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => 0644,
    require => File["${pe_repodata}/CentOS/6/puppetenterprise"],
  }

  file{"${pe_repodata}/CentOS/6/puppetenterprise":
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => 0644,
    require => File["${pe_repodata}/CentOS/6"],
  }

  exec{"unpack-el-6-x86_64":
    command => "tar -xzf -C ${pe_repodata} ${pe_repodata}/puppet-enterprise-${pe_version}-all.tar.gzi && mv ${pe_repodata}/puppet-enterprise-${pe_version}-all/packages/el-6-x86_64/* ${pe_repodata}/CentOS/6/puppetenterprise/x86_64/",
    creates => "${pe_repodata}/puppet-enterprise-${pe_version}-all",
    require => [
      File["${pe_repodata}/CentOS/6/puppetenterprise/x86_64"],
      Exec["download-pe"]
    ]
  }

  package{"createrepo":
    ensure => installed,
  }

  exec{"createrepo-el-6-x86_64":
    command => "/usr/bin/createrepo ${pe_repodata}/CentOS/6/puppetenterprise/x86_64/",
    creates => "${pe_repodata}/CentOS/6/puppetenterprise/x86_64/repodata/repomd.xml",
    require => [
      Package["createrepo"],
      Exec["unpack-el-6-x86_64"]
    ]
  }

  apache::vhost{'master.puppetlabs.vm':
    docroot  => "${pe_repodata}",
    priority => 10,
    port     => 80,
  }

}
