# encoding: utf-8
require 'rails/generators'
require 'rails/generators/base'

module AnAxe
  module Generators
    # Copies AnAxe public assets to public/assets/[javascripts|stylesheets|images]/an_axe (Rails 3.0.X only, Rails 3.1 has asset pipeline)
    #
    # @example
    #   $ rails generate an_axe:[install|image|javascript|stylesheet] --pipeline [true|false]
    #

    class Base < Rails::Generators::Base
      class_option :pipeline, :type => :boolean, :aliases => "-p", :desc => "Install within asset pipeline search path, or to non-pipelined public/. Available options are 'true' and 'false'.", :default => 'true'
    end

  end
end
