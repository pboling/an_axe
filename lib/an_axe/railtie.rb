require "rails"

# Add AnAxe JS (not needed with asset pipeline)
module AnAxe
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      config.action_view.javascript_expansions[:an_axe] = %w(an_axe)
    end
  end
end

#require "rails/railtie"
#
#module Cells
#  class Railtie < ::Rails::Railtie
#    initializer "cells.attach_router" do |app|
#      Cell::Base.class_eval do
#        include app.routes.url_helpers
#      end
#    end
#
#    initializer "cells.setup_view_paths" do |app|
#      Cell::Base.setup_view_paths!
#    end
#
#    initializer "cells.setup_engines_view_paths" do |app|
#      Cells::Engines.append_engines_view_paths_for(app.config.action_controller)
#    end
#
#    rake_tasks do
#      load "cells/cells.rake"
#    end
#  end
#end
