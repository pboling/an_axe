# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "an_axe"
  gem.homepage = "http://github.com/pboling/an_axe"
  gem.license = "MIT"
  gem.summary = %Q{TODO: Rails 3 Engine implementation of Modern Savage Beast}
  gem.description = %Q{An Axe is a Rails3 update and Enginification of Modern Savage Beast, which is a revision
of the old Savage Beast Plugin.

Savage Beast is a Rails forum plugin based on the popular Beast plugin.
The Savage Beast plugin has been installed in hundreds of Rails sites, partially
because it's the only viable choice for a message forum plugin, but also because
it incorporates a lot of features that would be a time-consuming headache for you
to implement yourself.

Differences from what may or may not be in any of the ancestors of An Axe:
  Views are now HAML
  I18n api for static text (no more gettext/gibberish)
  Works with Rails 3.X and Ruby 1.9.2

Goals:
  Seamless Upgrade from some flavors of (Modern) Savage Beast}
  gem.email = "peter.boling@gmail.com"
  gem.authors = ["Peter Boling", "William B Harding"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

#require 'reek/rake/task'
#Reek::Rake::Task.new do |t|
#  t.fail_on_error = true
#  t.verbose = false
#  t.source_files = 'lib/**/*.rb'
#end
#
#require 'roodi'
#require 'roodi_task'
#RoodiTask.new do |t|
#  t.verbose = false
#end

task :default => :spec

#require 'yard'
#YARD::Rake::YardocTask.new
