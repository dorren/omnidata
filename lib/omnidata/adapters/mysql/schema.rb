module Omnidata
  module Adapters
    module Mysql
      class Schema
        attr_reader :database

        def initialize(database)
          @database = database
        end

        def create_model_table(table_name)
          return if table_exists?(table_name)

          sql = %{CREATE TABLE #{table_name} (
                      added_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                      id VARCHAR(32) NOT NULL,
                      updated TIMESTAMP NOT NULL,
                      body MEDIUMBLOB,
                      UNIQUE KEY (id),
                      KEY (updated)
                  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;}
          execute(sql)
        end

        # sample fields
        #   [{:name => 'user_id', :type => String, :limit => 100}]
        def create_index_table(table_name, fields)
          fields_part = fields.collect{|field|
                         "#{field[:name]} #{field[:type]} NOT NULL"
                       }.join(',')
          keys_part = fields.collect{|field| field[:name]}.join(", ")

          sql =%{CREATE TABLE #{table_name} (
                   #{fields_part},
                   PRIMARY KEY (#{keys_part})
                 ) ENGINE=InnoDB DEFAULT CHARSET=utf8;}
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
