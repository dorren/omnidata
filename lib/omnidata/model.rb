require 'active_support/concern'
require 'virtus'

module Omnidata
  # used by both Model and Mysql Index class.
  module Core
    extend ActiveSupport::Concern

    included do
      include ModelHooks
      include Virtus
      include Persistence
      include Orm
    end
  end

  module Model
    extend ActiveSupport::Concern

    included do
      include Core
      include PrimaryKey
      include Indexing
    end
  end
end
