gem 'mysql2'
require 'mysql2'
require 'uuid'
require 'json'
require 'omnidata/adapters/mysql/schema'

# use mysql like nosql. 
# @see http://backchannel.org/blog/friendfeed-schemaless-mysql
#
# NOT complete.
# Haven't figure best way to generate query sql.
module Omnidata
  module Adapters
    class MysqlAdapter < AbstractAdapter

      def uuid_generator
        @uuid_gen || UUID.new
      end

      def gen_uuid
        uuid_generator.generate(:compact)
      end

      def database
        @db ||= begin
          host = config[:host] || 'localhost'
          port = config[:port] || 3306
          client = Mysql2::Client.new(
                             :host => host, 
                             :port => port,
                             :database => config[:database],
                             :username => config[:username],
                             :password => config[:password])
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
        create_model_table(table_name)
        result = database.query("SELECT * from #{table_name} WHERE id = '#{pk}'")
        build_attributes(result.first)
      end

      def find_all(query, table_name)
        create_model_table(table_name)
        sql = build_sql(query, table_name)
        result = database.query(sql)
        result.collect{|x| build_attributes(x)}
      end

      def create(table_name, attrs)
        create_model_table(table_name)
        model_id = gen_uuid
        body = attrs.to_json
        res = database.query("INSERT INTO #{table_name} (id, body) values ('#{model_id}', '#{body}')")
        model_id
      end

      def update(pk, table_name, attrs)
        create_model_table(table_name)
        table(table_name).update({"_id" => pk}, {"$set" => attrs})
      end

      def count(table_name)
        create_model_table(table_name)
        res = database.query("SELECT COUNT(id) FROM #{table_name}")
        res.first.values.first
      end

      def destroy(pk, table_name)
        create_model_table(table_name)
        database.query("DELETE FROM #{table_name} WHERE id='#{pk}'")
      end

      def delete_all(table_name)
        create_model_table(table_name)
        database.query("DELETE FROM #{table_name}")
      end


      def create_model_table(table_name)
        schema = Mysql::Schema.new(database)
        schema.create_model_table(table_name)
      end

      # sample fields
      #   [{:name => 'user_id', :type => String, :limit => 100}]
      def create_index_table(table_name, fields)
        schema = Mysql::Schema.new(database)
        schema.create_index_table(table_name)
      end


      def build_sql(query, table_name)
        meta_query = build_meta_query(query)
        sql = "SELECT * from #{table_name}"
        sql += " ORDER BY #{meta_query[:order]}" if meta_query[:order]
        sql += " LIMIT  #{meta_query[:limit]}"   if meta_query[:limit]
        sql += " OFFSET #{meta_query[:skip]}"    if meta_query[:skip]
        sql
      end


      private

      def build_attributes(db_attrs)
        return nil if db_attrs.nil?

        body = db_attrs.delete('body')
        db_attrs.merge(JSON.parse(body))
      end


      # separate out :limit and :skip params from main query hash.
      #
      def build_meta_query(query)
        meta_query = {}
        if query.kind_of?(Hash)
          [:limit, :skip, :order].each do |x|
            meta_query[x] = query.delete(x) if query[x]
          end
        end
        meta_query
      end
    end
  end
end
