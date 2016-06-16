#
# Cookbook Name:: oreno_rds
# Recipe:: consul
#
# Copyright 2014, Masashi Terui
#
# Apache 2.0 License
#

package 'unzip'

directory node['oreno']['base_dir']

execute 'unzip_consul' do
  command <<-EOS
unzip consul.zip
chmod 755 consul
rm -f consul.zip
  EOS
  cwd node['oreno']['base_dir']
  action :nothing
end

remote_file "#{node['oreno']['base_dir']}/consul.zip" do
  source "https://releases.hashicorp.com/consul/#{node['oreno']['consul_version']}/consul_#{node['oreno']['consul_version']}_linux_amd64.zip"
  notifies :install, 'execute[unzip_consul]', :immediately
end
