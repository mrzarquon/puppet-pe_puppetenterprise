class pe_puppetenterprise::elrepo(
  $pe_tarball = $pe_puppetenterprise::params::pe_tarball,
  $pe_version = $pe_puppetenterprise::params::pe_version,
  $pe_url = $pe_puppetenterprise::params::pe_url,
  $pe_repodata = $pe_puppetenterprise::params::pe_repodata,
  $pe_master = $pe_puppetenterprise::params::pe_master,
  $pe_installer = $pe_puppetenterprise::params::pe_installer
) inherits pe_puppetenterprise::params {
  include apache

  file{$pe_repodata:
    ensure  => directory,
    owner   => "www-data",
    group   => "www-data",
    mode    => 0644,
  }

  file{"${pe_repodata}/${pe_installer}/packages/centosKS.cfg":
    ensure  => file,
    owner   => "www-data",
    group   => "www-data",
    mode    => 0644,
    require => Exec["unpack-install"],
    source  => 'puppet:///modules/pe_puppetenterprise/centosKS.cfg',
  }

  exec{'download-pe':
    command => "/usr/bin/curl -O $pe_url",
    cwd     => $pe_repodata,
    creates => "${pe_repodata}/${pe_tarball}",
    require => File[$pe_repodata],
    timeout => 1200,
  }

  exec{"unpack-install":
    command => "/bin/tar -xzf ${pe_repodata}/${pe_tarball}",
    cwd     => "${pe_repodata}",
    creates => "${pe_repodata}/${pe_installer}",
    require => [
      File["${pe_repodata}"],
      Exec["download-pe"],
    ]
  }

  package{"createrepo":
    ensure => installed,
  }

  exec{"createrepo-el-6-x86_64":
    command => "/usr/bin/createrepo ${pe_repodata}/${pe_installer}/packages/el-6-x86_64",
    creates => "${pe_repodata}/${pe_installer}/packages/el-6-x86_64/repodata/repomd.xml",
    require => [
      Package["createrepo"],
      Exec["unpack-install"]
    ]
  }
  exec{"createrepo-el-6-i386":
    command => "/usr/bin/createrepo ${pe_repodata}/${pe_installer}/packages/el-6-i386",
    creates => "${pe_repodata}/${pe_installer}/packages/el-6-i386/repodata/repomd.xml",
    require => [
      Package["createrepo"],
      Exec["unpack-install"]
    ]
  }
  exec{"createrepo-el-5-x86_64":
    command => "/usr/bin/createrepo ${pe_repodata}/${pe_installer}/packages/el-5-x86_64",
    creates => "${pe_repodata}/${pe_installer}/packages/el-5-x86_64/repodata/repomd.xml",
    require => [
      Package["createrepo"],
      Exec["unpack-install"]
    ]
  }
  exec{"createrepo-el-5-i386":
    command => "/usr/bin/createrepo ${pe_repodata}/${pe_installer}/packages/el-5-i386",
    creates => "${pe_repodata}/${pe_installer}/packages/el-5-i386/repodata/repomd.xml",
    require => [
      Package["createrepo"],
      Exec["unpack-install"]
    ]
  }
  
  file{"/etc/apache2/ports.conf":
    ensure => file,
    owner  => "root",
    group  => "root",
    mode   => "0644",
    source => "puppet:///modules/pe_puppetenterprise/ports.conf",
  }
  
  apache::vhost{"${pe_master}":
    docroot  => "${pe_repodata}/${pe_installer}/packages/",
    priority => 10,
    port     => 80,
    template => "apache/vhost-default.conf.erb",
    require  => Exec["unpack-install"],
  }

  file{"${pe_repodata}/${pe_installer}/packages/puppetenterprise-el.repo":
    ensure  => file,
    owner   => www-data,
    group   => www-data,
    content => template("pe_puppetenterprise/puppetenterprise-elrepo.erb"),
    require => Exec["createrepo-el-6-x86_64"],
  }


}
