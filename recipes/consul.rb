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
  EOS
  cwd node['oreno']['base_dir']
  action :nothing
end

remote_file "#{node['oreno']['base_dir']}/consul.zip" do
  source "https://releases.hashicorp.com/consul/#{node['oreno']['consul_version']}/consul_#{node['oreno']['consul_version']}_linux_amd64.zip"
  notifies :install, 'execute[unzip_consul]', :immediately
end

package 'mysql-community-server'
package 'mysql-utilities'

directory '/etc/mysql.d'

template '/etc/my.cnf' do
  source 'my.cnf.erb'
  action :create
  variables({
   :server_id => node['oreno_rds']['server_id'].nil? node['ipaddress'].match(/^\d+\.\d+\.\d+\.(\d+)\$/)[1] : node['ipaddress'],
   :report_host => node['ipaddress'],
   :datadir => node['oreno_rds']['datadir'],
   :socket => node['oreno_rds']['socket'],
   :log_error => node['oreno_rds']['log-error'],
   :pid_file => node['oreno_rds']['pid-file'],
  })
end

service 'mysqld' do
  supports :status => true, :restart => true, :reload => false
  action [:enable, :start]
end
