#
# Cookbook Name:: oreno_rds
# Recipe:: mysql
#
# Copyright 2014, Masashi Terui
#
# Apache 2.0 License
#

include_recipe 'database::mysql'

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

package 'gzip'
package 'mysql-community-server'
package 'mysql-community-libs'
package 'mysql-community-utilities'
package 'mysql-community-client'

directory '/etc/mysql.d'

template '/etc/my.cnf' do
  source 'my.cnf.erb'
  action :create
  variables({
   :server_id => node['oreno_rds']['server_id'].nil? node['ipaddress'].match(/^\d+\.\d+\.\d+\.(\d+)\$/)[1] : node['ipaddress'],
   :report_host => node['ipaddress'],
   :datadir => node['oreno_rds']['datadir'],
   :socket => node['oreno_rds']['socket'],
   :log_error => node['oreno_rds']['log_error'],
   :pid_file => node['oreno_rds']['pid_file'],
   :server_type => node['oreno_rds']['server_type'],
  })
end

service 'mysqld' do
  supports :status => true, :restart => true, :reload => false
  action [:enable, :start]
end

mysql_connection_info = {:host => 'localhost', :username => 'root'}

mysql_database_user node['oreno']['replica_user'] do
  connection mysql_connection_info
  host node['oreno']['replica_hosts']
  password node['oreno']['replica_password']
  privileges ['REPLICATION SLAVE']
  action [:create, :grant]
end

file "#{node['oreno']['base_dir']}/full-backup.sh" do
  mode '0755'
  content <<-EOL
TODAY = `date +"%Y%m%d"`
mysqldump -u root --all-databases --single-transaction --master-data 2 | gzip > /tmp/$TODAY.gz
aws s3 put-object /tmp/$TODAY.gz s3://#{node['oreno']['backup_bucket']}/full/$TODAY.gz
rm -f /tmp/$TODAY.gz
EOL
  action :create
end

cron 'full-backup' do
  command "/bin/sh #{node['oreno']['base_dir']}/full-backup.sh"
  hour node['oreno']['daily_backup_hour']
  minute node['oreno']['daily_backup_minutes']
  only_if node['oreno']['server_type'] == 'standby'
end

# TODO: PITR
