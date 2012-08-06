module AnAxe
  class MonitorshipsSweeper < ActionController::Caching::Sweeper
    observe Monitorship

    # If our sweeper detects that a Monitorship was created call this
    def after_create(monitorship)
      expire_cache_for(monitorship)
    end

    # If our sweeper detects that a Monitorship was updated call this
    def after_update(monitorship)
      expire_cache_for(monitorship)
    end

    # If our sweeper detects that a Monitorship was deleted call this
    def after_destroy(monitorship)
      expire_cache_for(monitorship)
    end

    private
    def expire_cache_for(monitorship)
      expire_action(monitored_all_posts_url)
      # Old Savage Beast:
      #FileUtils.rm_rf File.join(RAILS_ROOT, 'public', 'users', monitorship.user_id.to_s)
    end
  end
end
