Simple PE Agent Installer Manifest
=====================

This is a basic class that is tested to setup a PE agent on a CentOS 6 64bit machine.

The repo.pp will download and stand up an apache based yum repo on a ubuntu system (testing on our vagrant/soupkitchen space), uses our apache 0.4.0 module. You have to disable 443 services by hand for it to work (to be fixed). It creates the appropriate .repo file to be retrieved for you.

On the master, create a bootstrap environment, with this module and pe\_puppetenterprise::agent declared as the default node in sites.pp.

The agent.pp will configure a centos 6 system to be a PE agent. to do so, do the following:

First, on the agent, set it to use the master as the repository:

`curl -o /etc/yum.repos.d/puppetenterprise.repo http://master/el-6-x86_64.repo`

Next, install pe-puppet:

`yum install pe-puppet`

Make sure you set your hostname if it's not set yet:

`hostname "centos63a"`

Now lets make the magic happen:

`/opt/puppet/bin/puppet agent -t --environment=bootstrap --ssldir="/etc/puppetlabs/puppet/ssl" --certname="centos63a" --server=master`

This will create the certificate (assumes you have autosigning turned on), drop said certificate into the final ssl directory, then check in to the bootstrap environment, where it will run the pe\_puppetenterprise::agent manifest, which configures the rest of the PE agent, and then enables the pe-puppet-agent service.

Running a `puppet agent -t` after this run will do all the magic of a normal first run in default environment on master stuff.

