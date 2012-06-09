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
        change_id(attrs)
      end

      def find_all(query, table_name)
        meta_query = build_meta_query(query)
        arr = table(table_name).find(query, meta_query)
        arr.collect{|x| change_id(x)}
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

      def delete_all(table_name)
        table(table_name).remove
      end

      private
      def build_key(pk)
        pk.kind_of?(String) ? BSON::ObjectId(pk) : pk
      end

      # convert mongodb's bson::objectId to just string
      def change_id(attrs)
        if attrs.kind_of?(Hash)
          attrs['id'] = attrs['_id'].to_s
        end
        attrs
      end

      def table(name)
        database.collection(name)
      end

      # separate out :limit and :skip params from main query hash.
      #
      # reference: 
      # https://github.com/mongodb/mongo-ruby-driver/blob/master/lib/mongo/collection.rb
      def build_meta_query(query)
        meta_query = {}
        if query.kind_of?(Hash)
          meta_query[:limit] = query.delete(:limit) if query[:limit]
          meta_query[:skip] = query.delete(:skip)   if query[:skip]
          meta_query[:sort] = [query.delete(:order), 1] if query[:order] # 1 = ASC, -1 = DESC
        end
        meta_query
      end
    end
  end
end

