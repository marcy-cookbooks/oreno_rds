#
# Cookbook Name:: oreno_rds
# Recipe:: default
#
# Copyright 2014, Masashi Terui
#
# Apache 2.0 License
#

directory "/usr/local/src/mysql_repo"

rpm_package "mysql_repo" do
  source "/usr/local/src/mysql_repo/mysql-community-release-el6-5.noarch.rpm"
  action :nothing
end

remote_file "/usr/local/src/mysql_repo/mysql-community-release-el6-5.noarch.rpm" do
  source "http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm"
  notifies :install, "rpm_package[mysql_repo]", :immediately
end

package "mysql-community-server"

directory "/etc/mysql.d"

template "/etc/my.cnf" do
  source "my.cnf.erb"
  action :create
end

service "mysqld" do
  supports :status => true, :restart => true, :reload => false
  action [:enable, :start]
end
