module AnAxe
  class Config

    @@settings ||= {
      :user_class    => nil,
      :user_scope_class    => nil,
      :user_scoped_method    => nil,
      :forum_scoped_method => nil,
      :forum_scope_class => nil,
      :forum_table_name => 'forums',
      :moderatorship_table_name => 'moderatorships',
      :monitorship_table_name => 'monitorships',
      :post_table_name => 'posts',
      :topic_table_name => 'topics',
      :logger => ::Rails.logger,
      :verbose => :debug,
      :verbose_inclusive => true
    }

    cattr_accessor :settings

    SAVAGE_BEAST_CONTROLLERS = [:forums, :posts, :topics, :moderators, :monitorships]

    def self.[](key)
      self.settings[key]
    end

    def self.user_scope_aware?
      !AnAxe::Config.user_scope_class.nil? &&
        !AnAxe::Config.user_scoped_method.nil?
    end

    def self.forum_scope_aware?
      !AnAxe::Config.forum_scope_class.nil? &&
        !AnAxe::Config.forum_scoped_method.nil?
    end

    def self.user_class
      self.settings[:user_class].constantize if self.settings[:user_class]
    end

    def self.forum_scope_class
      self.settings[:forum_scope_class].constantize if self.settings[:forum_scope_class]
    end

    def self.user_scope_class
      self.settings[:user_scope_class].constantize if self.settings[:user_scope_class]
    end
    
    # as a symbol
    def self.user_scoped_method
      self.settings[:user_scoped_method]
    end

    # as a symbol
    def self.forum_scoped_method
      self.settings[:forum_scoped_method]
    end

    # as a symbol
    def self.user_relation
      AnAxe::Config.settings[:user_class].underscore.downcase.to_sym
    end

    def self.logger
      AnAxe::Config.settings[:logger]
    end

    def self.configure(&block)
      yield @@settings

      #Validate configuration right then and there...
      unless self.settings[:user_class].respond_to?(:constantize) && user_klass = self.settings[:user_class].constantize && defined?(user_klass)
        raise InvalidConfiguration, "AnAxe::Config.settings[:user_class] is invalid: #{self.settings[:user_class]} cannot be constantized, or is not defined."
      end
      unless self.settings[:user_scope_class].respond_to?(:constantize) && user_scope_klass = self.settings[:user_scope_class].constantize && defined?(user_scope_klass)
        raise InvalidConfiguration, "AnAxe::Config.settings[:user_scope_class] is invalid: #{self.settings[:user_scope_class]} cannot be constantized, or is not defined."
      end
      unless self.settings[:user_scoped_method].nil? || self.settings[:user_scoped_method].is_a?(Symbol)
        raise InvalidConfiguration, "AnAxe::Config.settings[:user_scoped_method] is invalid: #{self.settings[:user_scoped_method]} must be nil, or a Symbol."
      end
      if (defined?(user_scope_klass) && !self.settings[:user_scoped_method].is_a?(Symbol)) || (self.settings[:user_scoped_method].is_a?(Symbol) && !(defined?(user_scope_klass)))
        raise InvalidConfiguration, "AnAxe::Config.settings[:user_scope_class] and AnAxe::Config.settings[:user_scoped_method] must both be set if either is set."
      end
      unless self.settings[:forum_scope_class].respond_to?(:constantize) && forum_scope_klass = self.settings[:forum_scope_class].constantize && defined?(forum_scope_klass)
        raise InvalidConfiguration, "AnAxe::Config.settings[:forum_scope_class] is invalid: #{self.settings[:forum_scope_class]} cannot be constantized, or is not defined."
      end
      unless self.settings[:forum_scoped_method].nil? || self.settings[:forum_scoped_method].is_a?(Symbol)
        raise InvalidConfiguration, "AnAxe::Config.settings[:forum_scoped_method] is invalid: #{self.settings[:forum_scoped_method]} must be nil, or a Symbol."
      end
      if (defined?(forum_scope_klass) && !self.settings[:forum_scoped_method].is_a?(Symbol)) || (self.settings[:forum_scoped_method].is_a?(Symbol) && !(defined?(forum_scope_klass)))
        raise InvalidConfiguration, "AnAxe::Config.settings[:forum_scope_class] and AnAxe::Config.settings[:forum_scoped_method] must both be set if either is set."
      end
    end

    def reloadable?() false; end
  end

  class InvalidConfiguration < StandardError
    # IDEA: make this more awesome with attributes and an initializer to dry up the error messages?
  end

end
