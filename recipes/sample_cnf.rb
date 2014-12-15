oreno_rds_cnf "sample" do
  params({
    'default_storage_engine'     => "InnoDB",
    'binlog_cache_size'          => 32768,
    'binlog_format'              => "MIXED",
    'innodb_file_per_table'      => 1,
    'innodb_flush_method'        => "O_DIRECT",
    'innodb_log_buffer_size'     => 8388608,
    'innodb_log_file_size'       => 134217728,
    'key_buffer_size'            => 16777216,
    'local_infile'               => 1,
    'log_output'                 => "TABLE",
    'log_slave_updates'          => 1,
    'master-info-repository'     => "TABLE",
    'max_binlog_size'            => 134217728,
    'performance_schema'         => 0,
    'read_buffer_size'           => 262144,
    'read_rnd_buffer_size'       => 524288,
    'relay_log_info_repository'  => "TABLE",
    'relay_log_recovery'         => 1,
    'skip-slave-start'           => 1,
    'sync_binlog'                => 1,
    'table_open_cache_instances' => 16,
    'thread_stack'               => 262144,
    'character_set_server'       => "utf8mb4"
  })
end

oreno_rds_autocnf "sample" do
  apply_immediately true
  params({
    'innodb_buffer_pool_size' => 3.0 / 4.0,
    'max_connections' => 1.0 / 12582880.0
  })
end
