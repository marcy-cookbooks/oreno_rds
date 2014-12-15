action :modify do

  cnf_content = "[mysqld]\n"
  if new_resource.params.length > 0
    new_resource.params.sort.each do |key,val|
      cnf_content << "#{key} = #{val}\n"
    end
  end

  file "/etc/mysql.d/oreno_#{new_resource.name.gsub(" ", "_")}.cnf" do
    user "root"
    group "root"
    mode "0644"
    content cnf_content
    notifies :restart, "service[mysqld]", :delayed if new_resource.apply_immediately
  end
end
