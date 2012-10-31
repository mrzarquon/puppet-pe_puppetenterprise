#/usr/bin/env ruby

require 'puppet'
require 'yaml'
require 'facter'


def generate_packages(packages, path = "#{File.dirname(__FILE__)}/packages.pp")
  entries = Array.new
  packages.each do |package|
    entries << <<-EOF
package { '#{package[:name]}': ensure => '#{package[:version]}' }
    EOF
  end
  File.open(path, 'w') { |f| f.write(entries.join("\n")) }
end

packages = Puppet::Type.type(:package).instances.select do |x| x.name =~ /pe\-/  end.collect do |x| {:version => x.provider.properties[:ensure], :name => x.name}  end

generate_packages(packages)
