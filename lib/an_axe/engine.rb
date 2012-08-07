require "an_axe"
require "rails"

module AnAxe
  class Engine < Rails::Engine
    isolate_namespace AnAxe
    engine_name :an_axe

    require 'an_axe/config'
    require 'an_axe/user_scope'
    require 'an_axe/authentication_stub'
    require 'an_axe/user_init'

    # This engine had plugins!!!
    #config.after_initialize do
    #  Rails.application.config.paths["vendor/plugins"].push File.expand_path('../../vendor/plugins', 'white_list')
    #  Rails.application.config.paths["vendor/plugins"].push File.expand_path('../../vendor/plugins', 'white_list_formatted_content')
    #end
    
    config.to_prepare do
      # Forums may be scoped within accounts/projects/groups/clubs/whatever.
      AnAxe::Forum.send :table_name=, AnAxe::Config.settings[:forum_table_name]

      AnAxe::Moderatorship.send :table_name=, AnAxe::Config.settings[:moderatorship_table_name]
      AnAxe::Moderatorship.belongs_to AnAxe::Config.settings[:user_class].underscore.downcase.to_sym,
                            :foreign_key => "user_id"

      AnAxe::Monitorship.send :table_name=, AnAxe::Config.settings[:monitorship_table_name]
      AnAxe::Monitorship.belongs_to AnAxe::Config.settings[:user_class].underscore.downcase.to_sym,
                            :foreign_key => "user_id"

      AnAxe::Post.send :table_name=, AnAxe::Config.settings[:post_table_name]
      AnAxe::Post.belongs_to AnAxe::Config.settings[:user_class].underscore.downcase.to_sym,
                            :counter_cache => :users_count,
                            :foreign_key => "user_id"

      AnAxe::Topic.send :table_name=, AnAxe::Config.settings[:topic_table_name]
      AnAxe::Topic.belongs_to AnAxe::Config.settings[:user_class].underscore.downcase.to_sym,
                            :foreign_key => "user_id"
      AnAxe::Topic.has_many :monitors,
                            :through => :monitorships,
                            :conditions => ["#{Monitorship.table_name}.active = ?", true],
                            :source => AnAxe::Config.settings[:user_class].underscore.downcase.to_sym
      AnAxe::Topic.belongs_to :replied_by_user,
                            :foreign_key => "replied_by",
                            :class_name => AnAxe::Config.settings[:user_class]

      AnAxe::Topic.has_many :voices,
                            :through => :posts,
                            :source => AnAxe::Config.settings[:user_class].underscore.downcase.to_sym,
                            :uniq => true

      # Users may be scoped within accounts/projects/groups/clubs/whatever.
      AnAxe::Config.user_class.send :include, AnAxe::UserScope
      # Posts are user specific, and this sets up all required AnAxe user relationships
      AnAxe::Config.user_class.send :include, AnAxe::UserInit
      # If you want a different relationship to forums then declare your own in your model, which will override this declaration
      AnAxe::Config.forum_scope_class.send :has_many, :forums, :order => "position", :dependent => :destroy if AnAxe::Config.forum_scope_class
    end
  end
end
