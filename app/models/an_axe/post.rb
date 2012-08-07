module AnAxe
  # TODO: Check against old version, to ensure dynamic implementation
  class Post < ActiveRecord::Base
    def self.per_page
      10
    end

    belongs_to :forum, :counter_cache => true
    belongs_to :topic, :counter_cache => true
    def user
      self.send(AnAxe::Config.user_relation)
    end

  # TODO: Consider switching away from Loofah
  #  extend Loofah::ActiveRecordExtension
  #  html_fragment :body, :scrub => :prune
  # For now preserve existing savage beast behavior
  #  format_attribute :body

    before_create { |r| r.forum_id = r.topic.forum_id }
    after_create  :update_cached_fields
    after_destroy :update_cached_fields

    validates_presence_of :user_id, :body, :topic
    validates_size_of :body, :maximum => 2**15 # 32k

    attr_accessible :body

    acts_as_taggable_on :bodies

    def self.search(text, options = {})
      query = text.downcase
      page = options[:page] || 1

      # Using acts_as_taggable_on to return posts that have been tagged with the query string
      tagged_posts = tagged_with(query)

      conditions = "lower(posts.body) LIKE :query"
      conditions << " OR posts.id IN (:post_ids)" unless tagged_posts.empty?

      paginate(
        :page => page,
        :order => "posts.created_at DESC",
        :conditions => [conditions, {:query => "%#{query}%", :post_ids => tagged_posts}],
        :include => [:topic, :forum]
      )
    end

    def editable_by?(user)
      user && (user.id == user_id || user.admin? || user.moderator_of?(forum_id))
    end

    def to_xml(options = {})
      options[:except] ||= []
      options[:except] << :topic_title << :forum_name
      super
    end

    protected
      # using count isn't ideal but it gives us correct caches each time
      def update_cached_fields
        Forum.update_all ['posts_count = ?', Post.count(:id, :conditions => {:forum_id => forum_id})], ['id = ?', forum_id]
        AnAxe::Config.user_class.update_posts_count(user_id) if AnAxe::Config.user_class.respond_to?(:update_posts_count)
        topic.update_cached_post_fields(self)
      end
  end
end
