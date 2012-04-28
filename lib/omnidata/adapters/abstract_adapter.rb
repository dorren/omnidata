require 'omnidata/adapters/adapter_manager'

module Omnidata
  # shortcut method
  def self.setup_database(name, options)
    Adapters::AdapterManager.instance.add(name, options)
  end

  def self.adapter(name)
    Adapters::AdapterManager.instance.adapter(name)
  end

  module Adapters
    class AbstractAdapter
      attr_accessor :name
      attr_reader :config

      def initialize(options)
        @config = options.dup
      end
    end
  end
end
