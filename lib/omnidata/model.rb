require 'active_support/concern'
require 'virtus'

module Omnidata
  module Model
    extend ActiveSupport::Concern

    included do
      include Virtus
      include Persistence
      include Orm
      include Indexing
    end
  end
end
