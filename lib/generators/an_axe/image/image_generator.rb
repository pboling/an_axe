# encoding: utf-8
require 'generators/an_axe/base'

module AnAxe
  module Generators
    # Copies AnAxe public image assets to public/assets/images/an_axe/  (Rails > 3.1 placement within asset pipeline path)
    # Copies AnAxe public image assets to public/images/an_axe/         (Rails 3.0.X only, or Rails > 3.1 without asset pipeline)
    #
    # @example
    #  $ rails generate an_axe:image --pipeline true
    #
    #    This will create all the images an_axe needs in:
    #        public/assets/images/an_axe/
    #
    #  $ rails generate an_axe:image --pipeline false
    #
    #    This will create all the images an_axe needs in:
    #        public/images/an_axe


    class ImageGenerator < AnAxe::Generators::Base
      source_root File.expand_path('../../../../../vendor/assets/images', __FILE__)
      desc "Copies AnAxe public image assets to public/assets/images/an_axe"
      def copy_files
        if options[:pipeline]
          directory 'an_axe',     'public/assets/images/an_axe', :recursive => true
        else
          directory 'an_axe',     'public/images/an_axe', :recursive => true
        end
      end
    end
  end
end
