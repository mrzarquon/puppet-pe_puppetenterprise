class pe_puppetenterprise::elrepo(
  $pe_tarball = $pe_puppetenterprise::params::pe_tarball,
  $pe_version = $pe_puppetenterprise::params::pe_version,
  $pe_url = $pe_puppetenterprise::params::pe_url,
  $pe_repodata = $pe_puppetenterprise::params::pe_repodata,
  $pe_master = $pe_puppetenterprise::params::pe_master
) inherits pe_puppetenterprise::params {
  include apache

  file{$pe_repodata:
    ensure => directory,
    owner  => "www-data",
    group  => "www-data",
    mode   => 0644,
  }

  exec{'download-pe':
    command => "/usr/bin/curl -O $pe_url",
    cwd     => $pe_repodata,
    creates => "${pe_repodata}/${pe_tarball}",
    require => File[$pe_repodata],
    before  => Exec["unpack-el-6-x86_64"],
    timeout => 900,
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
    command => "/bin/tar -xzf ${pe_repodata}/${pe_tarball} && /bin/mv ${pe_repodata}/puppet-enterprise-${pe_version}-all/packages/el-6-x86_64/* ${pe_repodata}/CentOS/6/puppetenterprise/x86_64/",
    cwd     => "${pe_repodata}",
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

  apache::vhost{"${pe_master}":
    docroot  => "${pe_repodata}",
    priority => 10,
    port     => 80,
    template => "apache/vhost-default.conf.erb",
  }

  file{"${pe_repodata}/el-6-x86_64.repo":
    ensure  => file,
    owner   => www-data,
    group   => www-data,
    content => template("pe_puppetenterprise/puppetenterprise-elrepo.erb"),
    require => Exec["createrepo-el-6-x86_64"],
  }


}
