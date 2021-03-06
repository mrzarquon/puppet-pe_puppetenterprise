class pe_puppetenterprise::params {
  $pe_agent_redhat = [
  pe-augeas, #pe-augeas-0.10.0-3.pe.el6.x86_64.rpm"
  pe-augeas-libs, #pe-augeas-libs-0.10.0-3.pe.el6.x86_64.rpm"
  pe-facter, #pe-facter-1.6.10-1.pe.el6.noarch.rpm"
  pe-mcollective, #pe-mcollective-1.2.1-13.pe.el6.noarch.rpm"
  pe-mcollective-common, #pe-mcollective-common-1.2.1-13.pe.el6.noarch.rpm"
  pe-puppet, #pe-puppet-2.7.19-3.pe.el6.noarch.rpm"
  pe-puppet-enterprise-release, #pe-puppet-enterprise-release-2.6.1-1.pe.el6.noarch.rpm"
  pe-ruby, #pe-ruby-1.8.7.370-1.pe.el6.x86_64.rpm 
  pe-ruby-augeas, #pe-ruby-augeas-0.4.1-1.pe.el6.x86_64.rpm 
  pe-rubygem-hiera, #pe-rubygem-hiera-0.3.0-333.pe.el6.noarch.rpm 
  pe-rubygem-hiera-puppet, #pe-rubygem-hiera-puppet-0.3.0-1.pe.el6.noarch.rpm 
  pe-rubygems, #pe-rubygems-1.5.3-1.pe.el6.noarch.rpm 
  pe-rubygem-stomp, #pe-rubygem-stomp-1.1.9-3.pe.el6.noarch.rpm 
  pe-rubygem-stomp-doc, #pe-rubygem-stomp-doc-1.1.9-3.pe.el6.noarch.rpm 
  pe-ruby-irb, #pe-ruby-irb-1.8.7.370-1.pe.el6.x86_64.rpm 
  pe-ruby-ldap, #pe-ruby-ldap-0.9.8-5.pe.el6.x86_64.rpm 
  pe-ruby-libs, #pe-ruby-libs-1.8.7.370-1.pe.el6.x86_64.rpm 
  pe-ruby-rdoc, #pe-ruby-rdoc-1.8.7.370-1.pe.el6.x86_64.rpm 
  pe-ruby-ri, #pe-ruby-ri-1.8.7.370-1.pe.el6.x86_64.rpm 
  pe-ruby-shadow, #pe-ruby-shadow-1.4.1-8.pe.el6.x86_64.rpm
  cronie,
  ]

  $pe_agent_debian = [
  pe-augeas-dbg,
  pe-augeas-tools, #pe-augeas-libs-0.10.0-3.pe.el6.x86_64.rpm"
  pe-facter, #pe-facter-1.6.10-1.pe.el6.noarch.rpm"
  pe-mcollective,
  pe-mcollective-client, #pe-mcollective-1.2.1-13.pe.el6.noarch.rpm"
  pe-mcollective-common, #pe-mcollective-common-1.2.1-13.pe.el6.noarch.rpm"
  pe-puppet-agent,
  "pe-puppet-common",
  pe-puppet-enterprise-release, #pe-puppet-enterprise-release-2.6.1-1.pe.el6.noarch.rpm"
  "pe-ri1.8",
  "pe-ruby1.8", #pe-ruby-1.8.7.370-1.pe.el6.x86_64.rpm 
  pe-rubygems-doc,
  pe-ruby-augeas, #pe-ruby-augeas-0.4.1-1.pe.el6.x86_64.rpm 
  pe-rubygem-hiera, #pe-rubygem-hiera-0.3.0-333.pe.el6.noarch.rpm 
  pe-rubygem-hiera-puppet, #pe-rubygem-hiera-puppet-0.3.0-1.pe.el6.noarch.rpm 
  "pe-rubygems1.8", #pe-rubygems-1.5.3-1.pe.el6.noarch.rpm 
  pe-rubygem-stomp, #pe-rubygem-stomp-1.1.9-3.pe.el6.noarch.rpm 
  pe-ruby-ldap, #pe-ruby-ldap-0.9.8-5.pe.el6.x86_64.rpm 
  pe-ruby-shadow, #pe-ruby-shadow-1.4.1-8.pe.el6.x86_64.rpm
  ]




  $pe_agent_dev = [
  pe-augeas-devel,
  pe-ruby-devel,
  ]

  $pe_agent_base = $operatingsystem ? {
    "Debian"           => $pe_agent_debian,
    "CentOS" => $pe_agent_redhat,
  }


  $pe_agent_pkgs = $pe_developer ? {
    "true"  => [ $pe_agent_base, $pe_agent_dev],
    default => $pe_agent_base,
  }


  $pe_master = 'master'
  $pe_installer = "puppet-enterprise-${pe_version}-all"
  $pe_tarball = "${pe_installer}.tar.gz"
  $pe_url = "https://s3.amazonaws.com/pe-builds/released/${pe_version}/${pe_tarball}"
  $pe_version = '2.6.1'
  $pe_repodata = '/opt/puppet/share/repodata'
}
