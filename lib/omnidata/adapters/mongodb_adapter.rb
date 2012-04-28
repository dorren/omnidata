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

      def find(query, table_name)
        if query.kind_of?(String) or query.kind_of?(Integer)
          find_one(query, table_name)
        else
          find_all(query, table_name)
        end
      end

      def find_one(pk, table_name)
        attrs = table(table_name).find_one("_id" => build_key(pk))
      end

      def find_all(query, table_name)
        meta_query = build_meta_query(query)
        arr = table(table_name).find(query, meta_query)
        arr.collect{|x| x['id'] = x['_id'].to_s; x}
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

      def build_meta_query(query)
        meta_query = {}
        meta_query[:limit] = query.delete(:limit) if query.kind_of?(Hash) and query[:limit]
        meta_query[:skip] = query.delete(:skip)   if query.kind_of?(Hash) and query[:skip]
        meta_query
      end
    end
  end
end

