module AnAxe

  module UserInit

    def self.included(base)
      base.has_many :moderatorships, :class_name => 'AnAxe::Moderatorship', :dependent => :destroy
      base.has_many :forums, :class_name => 'AnAxe::Forum', :through => :moderatorships, :order => "#{AnAxe::Config.settings[:forum_table_name]}.name"
      base.has_many :posts, :class_name => 'AnAxe::Post'
      base.has_many :topics, :class_name => 'AnAxe::Topic'
      base.has_many :monitorships, :class_name => 'AnAxe::Monitorship'
      base.has_many :monitored_topics, :through => :monitorships, :conditions => ["#{AnAxe::Config.settings[:moderatorship_table_name]}.active = ?", true], :order => "#{AnAxe::Config.settings[:topic_table_name]}.replied_at desc", :source => :topic
      base.extend(ClassMethods)
    end

    #implement in your user model
    def display_name
      ActiveSupport::Deprecation.warn("You must setup An Axe in your app by overriding the method :display_name on #{self.class}")
      "Foo Diddly"
    end

    #implement in your user model
    def admin?
      ActiveSupport::Deprecation.warn("You must setup An Axe in your app by overriding the method :admin? on #{self.class}")
      false
    end

    def moderator_of?(forum)
      moderatorships.count(:all, :conditions => ['forum_id = ?', (forum.is_a?(Forum) ? forum.id : forum)]) == 1
    end

    def to_xml(options = {})
      options[:except] ||= []
      super
    end

    module ClassMethods
      #implement in the model that includes AnAe::UserInit

      def search(query, options = {})
        with_scope :find => {:conditions => build_search_conditions(query)} do
          options[:page] ||= nil
          paginate options
        end
      end

      #implmement to build search conditions
      def build_search_conditions(query)
        #ActiveSupport::Deprecation.warn("You must setup An Axe in your app by overriding the method :build_search_conditions(query) on #{self.class}")
        query && ['LOWER(display_name) LIKE :q OR LOWER(login) LIKE :q', {:q => "%#{query}%"}]
        #query
      end

      def moderator_of?(forum)
        moderatorships.count("#{Moderatorship.table_name}.id", :conditions => ['forum_id = ?', (forum.is_a?(Forum) ? forum.id : forum)]) == 1
      end

      def to_xml(options = {})
        options[:except] ||= []
        options[:except] << :email << :login_key << :login_key_expires_at << :password_hash << :openid_url << :activated << :admin
        super
      end

      def update_posts_count
        self.update_posts_count id
      end

      def update_posts_count(id)
        self.update_all ['posts_count = ?', Post.count(:id, :conditions => {:user_id => id})], ['id = ?', id]
      end

    end

  end
end
