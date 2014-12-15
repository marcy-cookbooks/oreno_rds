require 'serverspec'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe command("mysql -uroot -e'show variables'") do
  its(:stdout) { should match /innodb_buffer_pool_size.*783286272/ }
  its(:stdout) { should match /max_connections.*83/ }
  its(:stdout) { should match /default_storage_engine.*InnoDB/ }
  its(:stdout) { should match /gtid_mode.*ON/ }
  its(:stdout) { should match /binlog_cache_size.*32768/ }
  its(:stdout) { should match /binlog_format.*MIXED/ }
  its(:stdout) { should match /innodb_file_per_table.*ON/ }
  its(:stdout) { should match /innodb_flush_method.*O_DIRECT/ }
  its(:stdout) { should match /innodb_log_buffer_size.*8388608/ }
  its(:stdout) { should match /innodb_log_file_size.*134217728/ }
  its(:stdout) { should match /key_buffer_size.*16777216/ }
  its(:stdout) { should match /local_infile.*ON/ }
  its(:stdout) { should match /log_output.*TABLE/ }
  its(:stdout) { should match /log_slave_updates.*ON/ }
  its(:stdout) { should match /master_info_repository.*TABLE/ }
  its(:stdout) { should match /max_binlog_size.*134217728/ }
  its(:stdout) { should match /performance_schema.*0/ }
  its(:stdout) { should match /read_buffer_size.*262144/ }
  its(:stdout) { should match /read_rnd_buffer_size.*524288/ }
  its(:stdout) { should match /relay_log_info_repository.*TABLE/ }
  its(:stdout) { should match /relay_log_recovery.*ON/ }
  its(:stdout) { should match /sync_binlog.*1/ }
  its(:stdout) { should match /table_open_cache_instances.*16/ }
  its(:stdout) { should match /thread_stack.*262144/ }
  its(:stdout) { should match /character_set_server.*utf8mb4/ }
end
