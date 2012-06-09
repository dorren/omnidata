module Omnidata
  module Adapters
    module Mysql
      # this class create index tables in db.
      #
      #   class User
      #     include Omnidata::Model
      #     use_database :db1
      #
      #     attribute :name, String
      #     attribute :age, Integer
      #     
      #     index :age
      #     index :name, :table_name => 'custom_index_table_name'
      #   end
      #
      #   User.find_by_age
      #   User.find_by_name
      class Index
      end
    end
  end
end

