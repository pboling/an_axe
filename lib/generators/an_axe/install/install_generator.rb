# encoding: utf-8
require 'generators/an_axe/base'

module AnAxe
  module Generators
    # Copies AnAxe public assets to public/assets/[images|javascripts|stylesheets]/an_axe/  (Rails > 3.1 placement within asset pipeline path)
    # Copies AnAxe public assets to public/[images|javascripts|stylesheets]/an_axe/         (Rails 3.0.X only, or Rails > 3.1 without asset pipeline)
    #
    # @example:
    #   $ rails generate an_axe:[image|javascript|stylesheet] --pipeline true
    #
    #    This will create all the [images|javascripts|stylesheets] an_axe needs in:
    #        public/assets/[images|javascripts|stylesheets]/an_axe/
    #
    #   $ rails generate an_axe:[image|javascript|stylesheet] --pipeline false
    #
    #    This will create all the [images|javascripts|stylesheets] an_axe needs in:
    #        public/[images|javascripts|stylesheets]/an_axe


    class InstallGenerator < AnAxe::Generators::Base
      def copy_assets
        generate('an_axe:image',      '--pipeline', options[:pipeline])
        generate('an_axe:javascript', '--pipeline', options[:pipeline])
        generate('an_axe:stylesheet', '--pipeline', options[:pipeline])
      end
    end
  end

end
