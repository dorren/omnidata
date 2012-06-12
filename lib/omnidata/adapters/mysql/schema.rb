module Omnidata
  module Adapters
    module Mysql
      # to be included into Model
      module ModelSchema
        extend ActiveSupport::Concern
        module ClassMethods
          def to_sql
            sql = %{CREATE TABLE #{table_name} (
                        added_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                        id VARCHAR(32) NOT NULL,
                        updated TIMESTAMP NOT NULL,
                        body MEDIUMBLOB,
                        UNIQUE KEY (id),
                        KEY (updated)
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;}
          end
        end
      end


      class Schema
        # convert ruby type to column types
        COLUMN_TYPES = {
          String   => { :name => "varchar", :limit => 255 },
          Integer  => { :name => "int", :limit => 4 },
          Date     => { :name => "date" },
          DateTime => { :name => "datetime" },
          Time     => { :name => "datetime" },
          }

        attr_reader :database

        def initialize(database)
          @database = database
        end

        def create_table(table_name, sql)
          return if table_exists?(table_name)
          execute(sql)
        end

        def table_exists?(table_name)
          sql = "show tables like '#{table_name}'"
          res = execute(sql)
          res.count == 1
        end

        def execute(sql)
          database.query(sql)
        end
      end
    end
  end
end
  
Omnidata::Model.send :include, Omnidata::Adapters::Mysql::ModelSchema

