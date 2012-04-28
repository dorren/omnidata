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
      attr_reader :adapter

      def use_database(name)
        adapter = Adapters::AdapterManager.instance.adapter(name)
        raise Adapters::AdapterError.new("adapter #{name} does not exist") if adapter.nil?
        @adapter = adapter
      end

      def build_model(attrs)
        model = new(attrs)
      end

      def find(query=nil)
        if query.kind_of?(String) or query.kind_of?(Integer)
          find_one(query)
        else
          find_all(query)
        end
      end

      def find_all(query)
        arr = adapter.find(query, table_name)
        arr.collect do |attrs|
          build_model(attrs)
        end
      end

      def find_one(pk)
        attrs = adapter.find(pk, table_name)
        if (attrs)
          build_model(attrs)
        end
      end

      def create(attrs)
        key = adapter.create(table_name, attrs)
        build_model(attrs.merge('id'=> key))
      end

      def update(pk, attrs)
        adapter.update(pk, table_name, attrs)
        self
      end

      def destroy(pk)
        adapter.destroy(pk, table_name)
        self
      end

      def count
        adapter.count(table_name)
      end

      def with_database(name, &block)
        old = self.adapter.name
        self.use_database(name)
        block.call
        self.use_database(old)
      end
    end
  end
end

