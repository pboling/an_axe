# encoding: utf-8
require 'generators/an_axe/base'

module AnAxe
  module Generators
    # Copies AnAxe public stylesheet assets to public/assets/stylesheets/an_axe/  (Rails > 3.1 placement within asset pipeline path)
    # Copies AnAxe public stylesheet assets to public/stylesheets/an_axe/         (Rails 3.0.X only, or Rails > 3.1 without asset pipeline)
    #
    # @example
    #   $ rails generate an_axe:stylesheet --pipeline true
    #
    #    This will create all the stylesheets an_axe needs in:
    #        public/assets/stylesheets/an_axe/
    #
    #  $  rails generate an_axe:stylesheet --pipeline false
    #
    #    This will create all the stylesheets an_axe needs in:
    #        public/stylesheets/an_axe

    class StylesheetGenerator < AnAxe::Generators::Base
      source_root File.expand_path('../../../../../vendor/assets/stylesheets/an_axe', __FILE__)
      desc "Copies AnAxe public stylesheet assets to public/assets/stylesheets/an_axe"
      def copy_files

        template 'an_axe.css',     'public/assets/stylesheets/a_axe/an_axe.css'
      end
    end
  end
end
