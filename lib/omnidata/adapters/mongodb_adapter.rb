gem 'mongo'
require 'mongo'

module Omnidata
  module Adapters
    class MongodbAdapter < AbstractAdapter
      def database
        @db ||= begin
          host = config[:host]
          port = config[:port]
          Mongo::Connection.new(host, port).db(config[:database])
        end
      end

      def find(pk, table_name)
        find_one(pk, table_name)
      end

      def find_one(pk, table_name)
        table(table_name).find_one("_id" => build_key(pk))
      end

      def create(table_name, attrs)
        key = table(table_name).insert(attrs)
        key.to_s
      end

      def update(pk, table_name, attrs)
        table(table_name).update({"_id" => pk}, {"$set" => attrs})
      end

      def count(table_name)
        table(table_name).count
      end

      def destroy(pk, table_name)
        table(table_name).remove("_id" => build_key(pk))
      end

      private
      def build_key(pk)
        pk.kind_of?(String) ? BSON::ObjectId(pk) : pk
      end

      def table(name)
        database.collection(name)
      end
    end
  end
end

