class pe_puppetenterprise::bootstrap{
  #create bootstrap environment
  file{"/etc/puppetlabs/puppet/environments/pe_bootstrap":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0644,
  }

  file{"/etc/puppetlabs/puppet/environments/pe_bootstrap/manifests":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0644,
  }

  file{"/etc/puppetlabs/puppet/environments/pe_bootstrap/modules":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0644,
  }

  file{"/etc/puppetlabs/puppet/environments/pe_bootstrap/manifests/site.pp":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => "0644",
    source => "puppet:///modules/pe_puppetenterprise/site.pp",
  }

  file{"/etc/puppetlabs/puppet/environments/pe_bootstrap/modules/pe_puppetenterprise":
    ensure => link,
    target => "/modules/pe_puppetenterprise",
  }

  file{"/etc/puppetlabs/puppet/environments/pe_bootstrap/hieradata/":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0644,
    source => "puppet:///modules/pe_puppetenterprise/hieradata",
  }

  file{"/etc/puppetlabs/puppet/environments/pe_bootstrap/hieradata/CentOS.yaml":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => 0644,
    source => "puppet:///modules/pe_puppetenterprise/hieradata/CentOS.yaml",
  }
}
