require 'serverspec'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe package('mysql-community-server') do
  it { should be_installed }
end

describe service('mysqld') do
  it { should be_enabled }
  it { should be_running }
end

file "/etc/mysql.d" do
  it { should be_directory }
end

file "/etc/my.cnf" do
  it { should be_file }
  it { should contain '!includedir /etc/mysql.d' }
end
