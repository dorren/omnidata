gem 'mongo'
require 'mongo'

module Omnidata
  module Adapters
    class MongodbAdapter < AbstractAdapter
      def database
        host = config[:host]
        port = config[:port]
        @db ||= Mongo::Connection.new(host, port).db(config[:database])
      end

      def create(table_name, attrs)
        coll = database.collection(table_name)
        key = coll.insert(attrs)
      end

      def count(table_name)
        coll = database.collection(table_name)
        coll.count
      end
    end
  end
end

