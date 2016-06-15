resource_name :oreno_conf
default_action :create

property :name, String, name_property: true
property :params, Hash, default: Hash.new
property :apply_immediately, [TrueClass, FalseClass], default: false

action :create do

  if node['memory']['total'].match(/MB$/)
    total_memory = node['memory']['total'].gsub(/MB$/, "").to_i * 1024 * 1024
  elsif node['memory']['total'].match(/kB$/)
    total_memory = node['memory']['total'].gsub(/MB$/, "").to_i * 1024
  else
    total_memory = node['memory']['total'].to_i
  end

  cnf_content = "[mysqld]\n"
  if params.length > 0
    params.sort.each do |k,v|
      v = eval(v.gsub('DBInstanceClassMemory', total_memory)).to_i if k.include?('DBInstanceClassMemory')
      cnf_content << "#{k} = #{v}\n"
    end
  end

  file "/etc/mysql.d/#{name.gsub(" ", "_")}.cnf" do
    user "root"
    group "root"
    mode "0644"
    content cnf_content
    notifies :restart, "service[mysqld]", :delayed if apply_immediately
  end
end

action :delete do
  file "/etc/mysql.d/#{name.gsub(" ", "_")}.cnf" do
    action :delete
    notifies :restart, "service[mysqld]", :delayed if apply_immediately
  end
end
