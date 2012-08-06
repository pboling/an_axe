module AnAxe
  module AuthenticationStub
    #this is a shell that Savage Beast uses to query the current user - override in your app controller

    def update_last_seen_at
      ActiveSupport::Deprecation.warn('You must setup An Axe in your app by overriding method :update_last_seen_at')
    end

    def login_required
      ActiveSupport::Deprecation.warn('You must setup An Axe in your app by overriding this method :login_required')
    end

    def authorized?
      ActiveSupport::Deprecation.warn('You must setup An Axe in your app by overriding this method :authorized?')
    end

    def current_user
      ActiveSupport::Deprecation.warn('You must setup An Axe in your app by overriding this method :current_user')
    end

    def logged_in?
      ActiveSupport::Deprecation.warn('You must setup An Axe in your app by overriding this method :logged_in?')
    end

    def admin?
      ActiveSupport::Deprecation.warn('You must setup An Axe in your app by overriding this method :admin?')
    end
  end
end
