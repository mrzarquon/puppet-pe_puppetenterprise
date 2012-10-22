class pe_puppetenterprise::agent(
  $pe_agent_pkgs = $pe_puppetenterprise::params::pe_agent_pkgs,
  $pe_master = $pe_puppetenterprise::params::pe_master
) inherits pe_puppetenterprise::params{

  package { $pe_agent_pkgs:
    ensure => present,
    before => File['/etc/puppetlabs/facter'],
  }

  file { '/etc/puppetlabs/facter':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0644,
  }

  file { '/etc/puppetlabs/facter/facts.d':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 0644,
    require => File['/etc/puppetlabs/facter'],
  }

  file { '/etc/puppetlabs/facter/facts.d/puppet_enterprise_installer.txt':
    ensure  => file,
    content => "fact_is_puppetagent=true
fact_stomp_port=61613
fact_stomp_server=master
fact_is_puppetmaster=false
fact_is_puppetca=false
fact_is_puppetconsole=false",
    require => File['/etc/puppetlabs/facter/facts.d'],
  }

  service { 'pe-puppet':
    ensure  => running,
    require => File['/etc/puppetlabs/puppet/puppet.conf'],
  }
  
  file {'/etc/puppetlabs/puppet/puppet.conf':
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => 0600,
    content => template("pe_puppetenterprise/puppet.conf.erb"),
    require => File['/opt/puppet/pe_version'],
  }

  file { '/opt/puppet/pe_version':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0400,
    content => "2.6.1",
    replace => "false",
    require => Package['pe-puppet'],
  }

  file { '/usr/local/bin/facter':
    ensure  => 'link',
    target  => '/opt/puppet/bin/facter',
    require => Package['pe-facter'],
  }

  file { '/usr/local/bin/puppet':
    ensure  => 'link',
    target  => '/opt/puppet/bin/puppet',
    require => Package['pe-puppet'],
  }

  file { '/usr/local/bin/hiera':
    ensure  => 'link',
    target  => '/opt/puppet/bin/facter',
    require => Package['pe-rubygem-hiera'],
  }


}
