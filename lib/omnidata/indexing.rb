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

      def index(fields)
        @indices ||= []

        arr = [*fields]
        arr.each do |field|
          @indices << field
        end
      end

    end
  end
end


