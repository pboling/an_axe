module AnAxe

  # In Rails 3 Engines lost the ability to mixin with the app models & controllers.
  # There are two workarounds:
  # 1. http://stackoverflow.com/questions/2964050/rails-engines-extending-functionality
  # 2. https://github.com/asee/mixable_engines
  #
  # These sorts of methods would be used for method #1.  Currently AnAxe uses #2
  #def self.root
  #  File.expand_path(File.dirname(File.dirname(__FILE__)))
  #end
  #
  #def self.models_dir
  #  "#{root}/app/models/an_axe"
  #end
  #
  #def self.controllers_dir
  #  "#{root}/app/controllers/an_axe"
  #end
  #
  #def self.helpers_dir
  #  "#{root}/app/helpers/an_axe"
  #end
  #
  #def self.lib_dir
  #  "#{root}/lib/an_axe"
  #end

  require 'an_axe/engine'
  require 'an_axe/railtie'

  def self.[](key)
    AnAxe::Config[key]
  end

  def self.config(key)
    AnAxe::Config.settings[key]
  end

  def self.logger
    return AnAxe::Config.logger if AnAxe::Config.logger.respond_to?(:debug)
    Logger.new(STDOUT)
  end

  def self.verbose(maximum_level)
    return false if AnAxe.config.verbose == false
    return case maximum_level
      when :low     then AnAxe::Config.verbose == :low
      when :med     then AnAxe::Config.settings[:verbose_inclusive] ? [:med, :low].include?(AnAxe::Config.verbose) : AnAxe::Config.verbose == :med
      when :high    then AnAxe::Config.settings[:verbose_inclusive] ? [:med, :low, :high].include?(AnAxe::Config.verbose) : AnAxe::Config.verbose == :high
      when :debug   then AnAxe::Config.settings[:verbose_inclusive] ? [:med, :low, :high, :debug].include?(AnAxe::Config.verbose) : AnAxe::Config.verbose == :debug
      when :silent  then AnAxe::Config.verbose == :silent
    end
    return true if AnAxe.config.verbose == true
  end

end
