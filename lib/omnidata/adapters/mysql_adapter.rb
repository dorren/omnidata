gem 'mysql2'
require 'mysql2'
require 'uuid'
require 'json'
require 'omnidata/adapters/mysql/schema'
require 'omnidata/adapters/mysql/index'

# use mysql like nosql. 
# @see http://backchannel.org/blog/friendfeed-schemaless-mysql
#
# NOT complete.
# Haven't figure best way to generate query sql.
module Omnidata
  module Adapters
    class MysqlAdapter < AbstractAdapter

      def uuid_generator
        @uuid_gen ||= UUID.new
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

      def find(query, model_class)
        if query.kind_of?(String) or query.kind_of?(Integer)
          find_one(query, model_class)
        else
          find_all(query, model_class)
        end
      end

      def find_one(pk, model_class)
        table_name = model_class.table_name
        create_model_table(model_class)
        result = database.query("SELECT * from #{table_name} WHERE id = '#{pk}'")
        build_attributes(result.first)
      end

      def find_all(query, model_class)
        table_name = model_class.table_name
        create_model_table(model_class)
        sql = build_sql(query, table_name)
        result = database.query(sql)
        result.collect{|x| build_attributes(x)}
      end

      def create(attrs, model_class)
        table_name = model_class.table_name
        create_model_table(model_class)
        model_id = gen_uuid
        body = attrs.to_json
        res = database.query("INSERT INTO #{table_name} (id, body) values ('#{model_id}', '#{body}')")
        model_id
      end

      def update(pk, attrs, model_class)
        table_name = model_class.table_name
        create_model_table(model_class)
        table(table_name).update({"_id" => pk}, {"$set" => attrs})
      end

      def count(model_class)
        table_name = model_class.table_name
        create_model_table(model_class)
        res = database.query("SELECT COUNT(id) FROM #{table_name}")
        res.first.values.first
      end

      def destroy(pk, model_class)
        table_name = model_class.table_name
        create_model_table(model_class)
        database.query("DELETE FROM #{table_name} WHERE id='#{pk}'")
      end

      def delete_all(model_class)
        table_name = model_class.table_name
        create_model_table(model_class)
        database.query("DELETE FROM #{table_name}")
      end


      def create_model_table(model_class)
        schema = Mysql::Schema.new(database)
        schema.create_table(model_class.table_name, model_class.to_sql)
      end

      def create_index_table(model_class)
        schema = Mysql::Schema.new(database)
        schema.create_table(model_class.table_name, model_class.to_sql)
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
