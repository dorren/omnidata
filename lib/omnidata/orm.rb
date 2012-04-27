require 'active_support/concern'

module Omnidata
  module Orm
    extend ActiveSupport::Concern

    included do
      attr_accessor :id
    end

    def new_record?
      self.id.nil?
    rescue
      true
    end


    module ClassMethods
      def table_name
        self.name.tableize.gsub("/", "_")
      end
    end
  end
end

