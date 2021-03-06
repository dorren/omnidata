require 'omnidata/adapters/abstract_adapter'
require 'omnidata/adapters/adapter_manager'
require 'omnidata/model_hooks'
require 'omnidata/persistence'
require 'omnidata/indexing'
require 'omnidata/orm'
require 'omnidata/primary_key'
require 'omnidata/model'

Omnidata::Adapters.autoload :MongodbAdapter, 'omnidata/adapters/mongodb_adapter'
Omnidata::Adapters.autoload :MysqlAdapter, 'omnidata/adapters/mysql_adapter'

