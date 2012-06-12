require 'active_support/concern'

module Omnidata
  # create sql index table.
  # If user want to list all users by age. He can do
  #   class User
  #     include Omnidata::Model
  #     index :age
  #   end
  #
  #   User.find(:order => :age)
  #
  # Then gem uses the default index table "index_users_age" to do
  # the query.
  #
  # @see http://backchannel.org/blog/friendfeed-schemaless-mysql
  module Indexing
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      attr_accessor :indices

      def index_name(fields)
        fields = [*fields]
        "#{self.table_name}_#{fields.join('_')}_index"
      end

      def index(fields, options={})
        fields = [*fields]
        idx_name = options[:name] || index_name(fields)
        
        all = []
        all << [name.foreign_key.to_sym, attributes[:id].options[:primitive]]

        fields.each do |f|
          attr = attributes[f]
          all << [attr.name, attr.options[:primitive]]
        end

        self.indices ||= {}
        self.indices[idx_name] = [idx_name, all, options]
      end

      # after class has adapter set, which is set by calling use_database
      def create_index(name)
        idx_cfg = self.indices[name]
        adapter.create_index(*idx_cfg)
      end
    end
  end
end


