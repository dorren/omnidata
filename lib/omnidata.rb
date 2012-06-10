require 'omnidata/adapters/abstract_adapter'
require 'omnidata/adapters/adapter_manager'
Omnidata::Adapters.autoload :MongodbAdapter, 'omnidata/adapters/mongodb_adapter'
Omnidata::Adapters.autoload :MysqlAdapter, 'omnidata/adapters/mysql_adapter'

require 'omnidata/persistence'
require 'omnidata/indexing'
require 'omnidata/orm'
require 'omnidata/model'

