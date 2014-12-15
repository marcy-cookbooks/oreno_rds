actions :modify
default_action :modify

attribute :params, :kind_of => Hash, :default => Hash.new
attribute :apply_immediately, :kind_of => [TrueClass, FalseClass], :default => false
