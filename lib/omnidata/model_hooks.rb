require 'active_support/concern'
require 'active_support/inflector'
require 'hooks'

module Omnidata
  # use hooks gem to trigger model callbacks
  # by default, you get :create, :update, :destroy defined.
  # But you can also define your own.
  #
  #   class Article
  #     define_model_hook :publish
  #
  #     before_publish :log_it
  #     after_publish  :email_it
  #
  #     def publish
  #       run_hooks(:save) do
  #         # publish article
  #       end
  #     end
  #   end
  #
  module ModelHooks
    extend ActiveSupport::Concern

    included do
      include Hooks
      define_model_hook(:create)
      define_model_hook(:update)
      define_model_hook(:destroy)
    end

    def run_hooks(name, *args, &block)
      self.class._run_hooks(name, self, *args, &block)
    end

    module ClassMethods
      def define_model_hook(name)
        define_hook("before_#{name}")
        define_hook("after_#{name}")
      end

      def run_hooks(name, *args, &block)
        _run_hooks(name, self, *args, &block)
      end

      def _run_hooks(name, scope, *args, &block)
        scope.run_hook("before_#{name}", *args)
        result = block.call
        scope.run_hook("after_#{name}", *args)
        result
      end
    end
  end
end
