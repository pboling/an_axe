#lib/authr/engine.rb
require "an_axe"
require "rails"

module AnAxe
  class Engine < Rails::Engine
    engine_name :an_axe
  end
end
