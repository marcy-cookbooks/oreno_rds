#
# Cookbook Name:: oreno_rds
# Recipe:: mysql
#
# Copyright 2014, Masashi Terui
#
# Apache 2.0 License
#

if platform_family?('rhel')
  pkg = "mysql#{node['oreno']['mysql_version'].sub('.', '')}-community-release-el#{node['platform_version'].to_i}-8.noarch.rpm"
end

directory base_dir

rpm_package 'mysql_repo' do
  source "#{node['oreno']['base_dir']}/#{pkg}"
  action :nothing
end

remote_file "#{node['oreno']['base_dir']}/#{pkg}" do
  source "http://dev.mysql.com/get/#{pkg}"
  notifies :install, 'rpm_package[mysql_repo]', :immediately
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
