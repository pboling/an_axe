# encoding: utf-8
require 'generators/an_axe/base'

module AnAxe
  module Generators
    # Copies AnAxe public javascript assets to public/assets/javascripts/an_axe/  (Rails > 3.1 placement within asset pipeline path)
    # Copies AnAxe public javascript assets to public/javascripts/an_axe/         (Rails 3.0.X only, or Rails > 3.1 without asset pipeline)
    #
    # @example
    #   $ rails generate an_axe:javascript --pipeline true
    #
    #    This will create all the javascript an_axe needs in:
    #        public/assets/javascripts/an_axe/
    #
    #   $ rails generate an_axe:javascript --pipeline false
    #
    #    This will create all the javascript an_axe needs in:
    #        public/javascript/an_axe

    class JavascriptGenerator < AnAxe::Generators::Base
      source_root File.expand_path('../../../../../vendor/assets/javascripts/an_axe', __FILE__)
      desc "Copies AnAxe public javascript assets to public/assets/javascripts/an_axe"
      def copy_files
        if options[:pipeline]
          template 'an_axe.js',     'public/assets/javascripts/an_axe/an_axe.js'
        else
          template 'an_axe.js',     'public/javascripts/an_axe/an_axe.js'
        end
      end
    end
  end
end
