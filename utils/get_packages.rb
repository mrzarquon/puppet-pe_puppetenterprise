#/opt/puppet/bin/ruby
require 'puppet'
require 'yaml'

data = Puppet::Type.type(:package).instances.select do |x| x.name =~ /pe\-/  end.collect do |x| {:version => x.provider.properties[:version], :name => x.name}  end
#puts YAML.something(data)
#
puts data.to_yaml
