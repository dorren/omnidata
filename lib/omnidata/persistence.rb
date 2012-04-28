require 'active_support/concern'
require 'active_support/inflector'

module Omnidata
  module Persistence
    extend ActiveSupport::Concern

    included do
    end

    def save
      if new_record?
        self.id = self.class.create(attributes)
      else
        self.class.update(id, attributes)
      end
      self
    end

    def destroy
      self.class.destroy(id)
    end
    
    module ClassMethods
      attr_reader :config

      # options 
      #   :adapter - mongodb
      #   :database - mydb
      def use_database(options)
        @config = options.dup
      end

      def adapter
        @adapter ||= begin
          name = config[:adapter].capitalize
          "Omnidata::Adapters::#{name}Adapter".constantize.new(config)
        end
      end

      def create(attrs)
        key = adapter.create(table_name, attrs)
      end

      def update(pk, attrs)
        adapter.update(pk, table_name, attrs)
      end

      def destroy(pk)
        adapter.destroy(pk, table_name)
      end

      def count
        adapter.count(table_name)
      end
    end
  end
end

