module AnAxe
  module UserScope

    # This module *MUST* be included in your 'user-ish' model if your 'users' are scoped,
    #     nested within some grouping top-level structure.
    #
    # An AxAxe does this for you... :) as long as you set:
    #
    #   AnAxe::Config.configure do |c|
    #     c[:user_class] = Person
    #   end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def an_axe_user_scope_aware?
        !AnAxe::Config.user_scope_aware?
      end

      def an_axe_user_scope
        @an_axe_user_scope ||= AnAxe::Config.user_scope_class.send(AnAxe::Config.user_scoped_method.to_sym)
      end

      # eg: User.currently_online
      def currently_online
        @currently_online ||= begin
          if self.an_axe_user_scope_aware?
            if self.an_axe_user_scope.respond_to?(:currently_online)
              # eg: Account.current_account.currently_online
              self.an_axe_user_scope.currently_online
            else
              ActiveSupport::Deprecation.warn("AnAxe Setup: Create an instance method :currently_online, on the #{AnAxe::Config.user_scope_class}.#{AnAxe::Config.user_scoped_method} class, which returns an array of #{AnAxe::Config.user_class.class} objects")
              []
            end
          else
            #eg: User.currently_online
            ActiveSupport::Deprecation.warn("AnAxe Setup: Define the method :currently_online in the #{self} class")
            []
          end
        end
      end

    end

  end
end
