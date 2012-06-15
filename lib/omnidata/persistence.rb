require 'active_support/concern'
require 'active_support/inflector'

module Omnidata
  module Persistence
    extend ActiveSupport::Concern

    def save
      if new_record?
        self.id = self.class.create(attributes)
      else
        self.class.update(id, attributes)
      end
      self
    end

    def destroy
      run_hooks :destroy do
        self.class.destroy(id)
      end
    end
    
    module ClassMethods
      attr_reader :adapter

      #set_callback :create, :before, :before_create 

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
        arr = adapter.find(query, self)
        arr.collect do |attrs|
          build_model(attrs)
        end
      end

      def find_one(pk)
        attrs = adapter.find(pk, self)
        if (attrs)
          build_model(attrs)
        end
      end

      def create(attrs)
        run_hooks :create do
          key = adapter.create(attrs, self)
          build_model(attrs.merge('id'=> key))
        end
      end

      def update(pk, attrs)
        run_hooks :update do
          adapter.update(pk, attrs, self)
          self
        end
      end

      def destroy(pk)
        adapter.destroy(pk, self)
        self
      end

      def delete_all
        adapter.delete_all(self)
      end

      def count
        adapter.count(self)
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

