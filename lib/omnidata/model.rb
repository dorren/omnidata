require 'active_support/concern'
require 'virtus'

module Omnidata
  module Model
    extend ActiveSupport::Concern

    included do
      include Virtus
      include Persistence
      include Orm
    end
  end
end
