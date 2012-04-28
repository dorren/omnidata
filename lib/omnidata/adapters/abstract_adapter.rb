module Omnidata
  module Adapters
    class AbstractAdapter
      attr_reader :config

      def initialize(options)
        @config = options.dup
      end
    end
  end
end
