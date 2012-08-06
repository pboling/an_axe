module AnAxe
  class Forum < ActiveRecord::Base
    acts_as_list

    validates_presence_of :name, :account_id
  #  validates_length_of :name, :maximum => 255
  #  validates_length_of :description, :maximum => 255
    validates_numericality_of :position

    has_many :moderatorships, :dependent => :delete_all
    has_many :moderators, :through => :moderatorships, :source => :user

    has_many :topics, :order => 'sticky desc, replied_at desc', :dependent => :delete_all, :include => :posts
    #has_one  :recent_topic, :class_name => 'Topic', :order => 'sticky desc, replied_at desc'

    # this is used to see if a forum is "fresh"... we can't use topics because it puts
    # stickies first even if they are not the most recently modified
    has_many :recent_topics, :class_name => 'AnAxe::Topic', :order => 'replied_at DESC', :include => :posts
    has_one  :recent_topic,  :class_name => 'AnAxe::Topic', :order => 'replied_at DESC', :include => :posts
    def self.recent_topic_el # for when they've all already been eager loaded
      self.topics.first
    end

    has_many :posts,     :order => "#{AnAxe[:post_table_name]}.created_at DESC", :dependent => :delete_all
    has_one  :recent_post, :order => "#{AnAxe[:post_table_name]}.created_at DESC", :class_name => 'Post'
    def self.recent_post_el # for when they've all already been eager loaded
      self.posts.first
    end

    scope :ordered, :order => 'forums.position'

  # TODO: Consider switching to Loofah
  #  extend Loofah::ActiveRecordExtension
  #  html_fragment :description, :scrub => :prune
  # For now preserve existing savage beast behavior
    format_attribute :description

    def self.an_axe_forum_scope_aware?
      !AnAxe::Config.forum_scope_aware?
    end

    def self.an_axe_forum_scope
      # eg: Account.current_account
      @an_axe_forum_scope ||= AnAxe::Config.forum_scope_class.send(AnAxe::Config.forum_scoped_method.to_sym)
    end

    # With or without a forum_scoped_method, this allows us to still use the same code :)
    def self.an_axe_forums
      @an_axe_forums ||= begin
        if self.an_axe_forum_scope_aware?
          if self.an_axe_forum_scope.respond_to?(:forums)
            self.an_axe_forum_scope.forums
          else
            ActiveSupport::Deprecation.warn("AnAxe Setup: Unknown failure :forums should be a relationship on this class #{self.an_axe_forum_scope.class}")
            []
          end
        else
          #TODO: Set default includes for the forum scope
          self.includes({:recent_post => :topic}, :recent_topic)
        end
      end
    end

  end
end
