require 'active_record'
require 'ruby-debug'
Debugger.start

#require File.join(File.dirname(__FILE__), '../task_util')
#include TaskUtil

SAVAGE_BEAST_BASE_DIR = File.join(File.dirname(__FILE__), "../..")

namespace :savage_beast do 
	desc "Add database tables for modern_savage_beast"
	task :bootstrap_db => :environment do
    migration_path = RAILS_ROOT + "/db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_create_savage_tables.rb"
    savage_beast_migration = File.join(SAVAGE_BEAST_BASE_DIR, 'db/migrate/', '001_create_savage_tables.rb')
    FileUtils.cp(savage_beast_migration, File.expand_path(migration_path))
		puts "Savage Beast migration copied to db/migrate.  Run rake db:migrate to complete the db bootstrap process."
	end

	desc "Copy the stylesheets and Javascripts used natively by bloggity into host app's public directory"
	task :bootstrap_assets => :environment do
		destination_root = RAILS_ROOT + "/public/"
    %w(stylesheets images javascripts).each{|asset|
      destination_path = destination_root + asset
      FileUtils.mkpath(destination_path) unless File.exists?(destination_path)
      FileUtils.mkpath(destination_path + "/savage_beast") unless File.exists?(destination_path + "/savage_beast")

      Dir[File.join(SAVAGE_BEAST_BASE_DIR, 'public', asset, '*')].each do |f|
        FileUtils.cp_r(f, File.expand_path(File.join(destination_root, asset, 'savage_beast')))
      end
    }
		puts "Files successfully copied!"

  end

  desc "Adds modern_savage_beasts gem requirements to enviroment.rb"
  task :add_gems => :environment do
    required_gems = "config.gem 'RedCloth'"
    look_for = 'Rails::Initializer.run do |config|'
    gsub_file 'config/environment.rb', /(#{Regexp.escape(look_for)})/mi do |match|
      "#{match}\n #{required_gems}\n"
    end
  end

  desc "Add includes for modern_savage_beast in application_helper and models/user"
  task :add_includes => :environment do
    inserts = [ [ "include SavageBeast::UserInit", "app/models/user.rb", "class User < ActiveRecord::Base"],
                [ "include SavageBeast::ApplicationHelper", "app/helpers/application_helper.rb", "module ApplicationHelper"] ]
    inserts.each do |i|
      gsub_file i[1], /(#{Regexp.escape(i[2])})/mi do |match|
        "#{match}\n #{i[0]}\n"
      end
    end
  end

  def gsub_file(path, regexp, *args, &block)
    content = File.read(path).gsub(regexp, *args, &block)
    File.open(path, 'wb') { |file| file.write(content) }
  end

=begin
	desc "Run all Bloggity tests"
	task :run_tests => :environment do 
		Rake::Task['bloggity:test:blog_posts'].invoke 
		Rake::Task['bloggity:test:blog_post'].invoke 
	end
	
	desc "Run a Bloggity test"
	rule "" do |t|
		# test:file:method
		if /bloggity\:test:(.*)(:([^.]+))?$/.match(t.name)
			arguments = t.name.split(":")[1..-1]
			arguments.delete("test")
			file_name = arguments.first
			test_name = arguments[1..-1] 
			
			if File.exist?(BLOGGITY_BASE_DIR + "/test/unit/#{file_name}_test.rb")
				run_file_name = "unit/#{file_name}_test.rb" 
			elsif File.exist?(BLOGGITY_BASE_DIR + "/test/functional/#{file_name}_controller_test.rb")
				run_file_name = "functional/#{file_name}_controller_test.rb" 
			elsif File.exist?(BLOGGITY_BASE_DIR + "/test/functional/#{file_name}_test.rb")
				run_file_name = "functional/#{file_name}_test.rb" 
			end
			
			sh "ruby -Ilib:test #{BLOGGITY_BASE_DIR}/test/#{run_file_name} -n /#{test_name}/"
		end
	end
=end
end

class CreateSavageTables < ActiveRecord::Migration
	def self.up
		create_table "forums" do |t|
	    t.string  "name"
	    t.string  "description"
	    t.integer "topics_count",     :default => 0
	    t.integer "posts_count",      :default => 0
	    t.integer "position"
	    t.text    "description_html"
	  end

	  create_table "moderatorships" do |t|
	    t.integer "forum_id"
	    t.integer "user_id"
	  end

	  add_index "moderatorships", ["forum_id"], :name => "index_moderatorships_on_forum_id"

	  create_table "monitorships" do |t|
	    t.integer "topic_id"
	    t.integer "user_id"
	    t.boolean "active",   :default => true
	  end

	  create_table "posts" do |t|
	    t.integer  "user_id"
	    t.integer  "topic_id"
	    t.text     "body"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.integer  "forum_id"
	    t.text     "body_html"
	  end

	  add_index "posts", ["forum_id", "created_at"], :name => "index_posts_on_forum_id"
	  add_index "posts", ["user_id", "created_at"], :name => "index_posts_on_user_id"
	  add_index "posts", ["topic_id", "created_at"], :name => "index_posts_on_topic_id"

	  create_table "topics" do |t|
	    t.integer  "forum_id"
	    t.integer  "user_id"
	    t.string   "title"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.integer  "hits",         :default => 0
	    t.integer  "sticky",       :default => 0
	    t.integer  "posts_count",  :default => 0
	    t.datetime "replied_at"
	    t.boolean  "locked",       :default => false
	    t.integer  "replied_by"
	    t.integer  "last_post_id"
	  end

	  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"
	  add_index "topics", ["forum_id", "sticky", "replied_at"], :name => "index_topics_on_sticky_and_replied_at"
	  add_index "topics", ["forum_id", "replied_at"], :name => "index_topics_on_forum_id_and_replied_at"

		add_column :users, :posts_count, :integer, :default => 0
    add_column :users, :last_seen_at, :datetime
  end

  def self.down
		remove_column :users, :posts_count
		remove_column :users, :last_seen_at

    drop_table :topics
    drop_table :posts
    drop_table :monitorships
    drop_table :moderatorships
    drop_table :forums
  end

end
