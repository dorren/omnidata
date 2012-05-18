require 'active_support/concern'

module Omnidata
  module Orm
    extend ActiveSupport::Concern

    included do
      attr_accessor :id
    end

    def new_record?
      self.id.nil?
    end


    module ClassMethods
      def table_name
        @table_name || self.name.tableize.gsub("/", "_")
      end

      def table_name=(str)
        @table_name = str
      end
    end
  end
end

