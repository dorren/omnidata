require 'singleton'

module Omnidata
  module Adapters
    class AdapterError < StandardError

    end

    class AdapterManager
      include Singleton

      attr_reader :adapters

      def initialize
        reset
      end

      def reset
        @adapters = {}
      end

      def add(name, options)
        if adapter(name)
          raise AdapterError.new("adapter #{name} exists")
        end

        adapter = build_adapter(options)
        adapter.name = name
        @adapters[name] = adapter
      end

      def build_adapter(options)
        opts = options.dup
        name = opts.delete(:adapter).capitalize
        "Omnidata::Adapters::#{name}Adapter".constantize.new(opts)
      end

      def adapter(name)
        @adapters[name]
      end
    end
  end
end
