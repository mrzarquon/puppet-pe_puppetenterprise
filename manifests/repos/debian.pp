class pe_puppetenterprise::repos::debian(
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

  package{"reprepro":
    ensure => installed,
  }

  file{"${pe_repodata}/${pe_installer}/packages/debian-6-i386/":
    ensure => directory,
    mode   => "0644",
  }

  file{"${pe_repodata}/${pe_installer}/packages/debian-6-i386/conf/":
    ensure => directory,
    mode   => "0644",
  }

  file{"${pe_repodata}/${pe_installer}/packages/debian-6-i386/conf/distributions":
    ensure  => file,
    mode    => "0644",
    content => template("pe_puppetenterprise/debian-6-i386.erb"),
  }

  exec{"createrepo-debian-6-i386":
    cwd     => "${pe_repodata}/${pe_installer}/packages/debian-6-i386/",
    command => "/usr/bin/reprepro -Vb . includedeb squeeze ${pe_repodata}/${pe_installer}/packages/debian-6-i386/*.deb",
    creates => "${pe_repodata}/${pe_installer}/packages/debian-6-i386/db/versions",
    require => [
      Package["reprepro"],
      File["${pe_repodata}/${pe_installer}/packages/debian-6-i386/conf/distributions"],
    ]
  }




  #create bootstrap environment
  file{"/etc/puppetlabs/puppet/environments/bootstrap":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0644,
  }

  file{"/etc/puppetlabs/puppet/environments/bootstrap/manifests":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0644,
  }

  file{"/etc/puppetlabs/puppet/environments/bootstrap/modules":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0644,
  }

  file{"/etc/puppetlabs/puppet/environments/bootstrap/manifests/site.pp":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => "0644",
    source => "puppet:///modules/pe_puppetenterprise/site.pp",
  }

  file{"/etc/puppetlabs/puppet/environments/bootstrap/modules/pe_puppetenterprise":
    ensure => link,
    target => "/modules/pe_puppetenterprise",
  }
}
