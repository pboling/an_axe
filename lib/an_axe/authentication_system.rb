module SavageBeast::AuthenticationSystem
#this is a shell that Savage Beast uses to query the current user - override in your app controller

  protected
    # this is used to keep track of the last time a user has been seen (reading a topic)
    # it is used to know when topics are new or old and which should have the green
    # activity light next to them
    #
    # we cheat by not calling it all the time, but rather only when a user views a topic
    # which means it isn't truly "last seen at" but it does serve it's intended purpose
    #
    # this could be a filter for the entire app and keep with it's true meaning, but that
    # would just slow things down without any forseeable benefit since we already know
    # who is online from the user/session connection
    #pg
    # This is now also used to show which users are online... not at accurate as the
    # session based approach, but less code and less overhead.
    def update_last_seen_at
      #return unless logged_in?
      #User.update_all ['last_seen_at = ?', Time.now.utc], ['id = ?', current_user.id]
      #current_user.last_seen_at = Time.now.utc
    end

    def login_required
      ActiveSupport::Deprecation.warn('You must setup An Axe in your app by overriding this method')
      if !current_user
        # redirect to login page
        return false
      end
    end

    def authorized?()
      ActiveSupport::Deprecation.warn('You must setup An Axe in your app by overriding this method')
      true
      # in your code, redirect to an appropriate page if not an admin
    end

    def current_user
      ActiveSupport::Deprecation.warn('You must setup An Axe in your app by overriding this method')
      #@current_user ||= ((session[:user_id] && User.find_by_id(session[:user_id])) || 0)
    end

    def logged_in?
      ActiveSupport::Deprecation.warn('You must setup An Axe in your app by overriding this method')
      current_user ? true : false #current_user != 0
    end

    def admin?
      logged_in? && current_user.admin?
    end
end
