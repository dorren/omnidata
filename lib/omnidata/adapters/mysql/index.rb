module Omnidata
  module Adapters
    module Mysql
      # this class create index tables in db.
      #
      #   index = Mysql::Index.new(
      #            :table_name => 'index_users_name', 
      #            :fields => [[:user_id, String],
      #                        [:first_name, String],
      #                        [:last_name, String]
      #                       ])
      #
      #
      # creates index class and stores in Model.indices
      #
      #   class IndexUserName
      #     include Omnidata::Model
      #     attribute :user_id,    String
      #     attribute :first_name, String
      #     attribute :last_name,  String
      #   end
      #
      #
      # build index
      #   index.create_table
      #   index.create(:user_id => '123', :first_name => 'John', :last_name => 'Doe')
      #
      # query
      #   id_arr = index.find(:first_name => "like 'John%")
      #   
      #
      #
      # used in model class
      #   class User
      #     include Omnidata::Model
      #     use_database :db1
      #
      #     attribute :name, String
      #     attribute :age, Integer
      #     
      #     index :age
      #     index [:first_name, :last_name], 
      #           :name => 'users_name',
      #           :foreign_key => :user_id
      #   end
      #
      #   User.indices('age').find("age > 10")
      #   User.indices('users_name').find("first_name='john'")
      #
      #   User.find(:age.gt => 10)
      #   User.find(:first_name.lt => 'John')
      class Index
        include Virtus
        include Persistence
        include Orm

        class << self
          attr_accessor :name
      
          # override Omnidata::Orm module's method
          def table_name
            @table_name ||= self.name
          end

          def to_sql
            fields_part = attributes.collect{|attr|
                           name = attr.name
                           column = Schema::COLUMN_TYPES[attr.options[:primitive]]
                           type = column[:limit] ? "#{column[:name]}(#{column[:limit]})" : "#{column[:name]}"
                           "#{name} #{type} NOT NULL"
                         }.join(",\n  ")
            keys_part = attributes.collect{|attr| "KEY (#{attr.name})"}.join(",\n  ")

            sql =%{\
CREATE TABLE #{table_name} (
  #{fields_part},
  #{keys_part}
) ENGINE=InnoDB DEFAULT CHARSET=utf8;}
          end

          def build_index_class(name, fields, options={})
            klass = Class.new(Index)
            klass.name = name

            fields.each do |field|
              klass.attribute *field
            end
            klass
          end
        end
      end
    end
  end
end
