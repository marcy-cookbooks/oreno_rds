action :modify do

  if node['memory']['total'].match(/MB$/)
    total_memory = node['memory']['total'].gsub(/MB$/, "").to_i * 1024 * 1024
  elsif node['memory']['total'].match(/kB$/)
    total_memory = node['memory']['total'].gsub(/MB$/, "").to_i * 1024
  else
    total_memory = node['memory']['total'].to_i
  end

  cnf_content = "[mysqld]\n"
  if new_resource.params.length > 0
    new_resource.params.sort.each do |key,val|
      memory = (total_memory * val).to_i
      cnf_content << "#{key} = #{memory}\n"
    end
  end

  file "/etc/mysql.d/oreno_auto_#{new_resource.name.gsub(" ", "_")}.cnf" do
    user "root"
    group "root"
    mode "0644"
    content cnf_content
    notifies :restart, "service[mysqld]", :delayed if new_resource.apply_immediately
  end
end
