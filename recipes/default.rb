#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2013, Myles Carrick
#
#

ruby_version = '1.9.3-p362'
ruby_version_concat = ruby_version.gsub(/-/,'')

# Prereqs without which we can't get off the ground
%w(build-essential wget libyaml-dev zlib1g-dev libssl-dev libreadline6-dev libxml2-dev).each do |dep|
  package dep
end

bash "ruby from source" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-#{ruby_version}.tar.gz
  tar -xzf ruby-#{ruby_version}.tar.gz
  cd ruby-#{ruby_version} && ./configure --prefix=/usr/local && make && sudo make install
  EOH
  not_if "ruby -v | grep #{ruby_version_concat}"
end

# Gem prereqs - might need reloading if we picked up new ruby/rubygems
%w(rake chef ohai bundler).each do |gem|
  gem_package gem
end
