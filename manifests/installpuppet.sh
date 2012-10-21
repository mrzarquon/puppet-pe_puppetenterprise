#!/bin/bash

#yum -y install createrepo - use to create local loopback repo

cat >> /etc/yum.repos.d/puppet-local.repo << _PUPPET_REPO
[local]
name=CentOS-\$releasever - local packages for \$basearch
baseurl=file:///files/CentOS/\$releasever/local/\$basearch
enabled=1
gpgcheck=0
protect=1
_PUPPET_REPO

yum -y install pe-puppet pe-facter pe-ruby

/opt/puppet/bin/puppet apply /modules/puppet-module-peagent/manifests/agent.pp

/opt/puppet/bin/puppet agent -t
