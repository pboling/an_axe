module AnAxe
  class PostsSweeper < ActionController::Caching::Sweeper
    observe Post # This sweeper is going to keep an eye on the Post model

    # If our sweeper detects that a Post was created call this
    def after_create(post)
      expire_cache_for(post)
    end

    # If our sweeper detects that a Post was updated call this
    def after_update(post)
      expire_cache_for(post)
    end

    # If our sweeper detects that a Post was deleted call this
    def after_destroy(post)
      expire_cache_for(post)
    end

    private
    def expire_cache_for(post)
      #expire_action(:controller => 'an_axe/forums/topics', :action => %w( show ), :id => post.id)
      #expire_action(forum_home_path(post.forum_id))
      #expire_action(forum_topic_path(post.forum_id, post.topic_id))

      # Old Savage Beast Expired RSS caches manually?
      #FileUtils.rm_rf File.join(RAILS_ROOT, 'public', 'forums', post.forum_id.to_s, 'posts.rss')
      #FileUtils.rm_rf File.join(RAILS_ROOT, 'public', 'forums', post.forum_id.to_s, 'topics', "#{post.topic_id}.rss")
      # For a users listing to have any use it would need to handle user_scope.
      #FileUtils.rm_rf File.join(RAILS_ROOT, 'public', 'users')
      #FileUtils.rm_rf File.join(RAILS_ROOT, 'public', 'posts.rss')
    end
  end
end
