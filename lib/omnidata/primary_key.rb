require 'active_support/concern'

module Omnidata
  module PrimaryKey
    extend ActiveSupport::Concern

    included do
      attribute :id, String
    end

    def new_record?
      self.id.nil?
    end


    module ClassMethods
    end
  end
end


