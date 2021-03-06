require 'digest/md5'
module AnAxe
  module ApplicationHelper
    #include AnAxe::AuthenticationStub

    def all_forums
      AnAxe::Forum.an_axe_forums
    end

    def online_users
      AnAxe::Config.user_class.currently_online
    end

    # convenient plugin point
    def head_extras
    end

    def post_count count
      count==1 ? t("savage_beast.post_count", :count => number_with_delimiter(count)) : t("savage_beast.posts_count", :count => number_with_delimiter(count))
    end

    def topic_count count
      count==1 ? t("savage_beast.topic_count", :count => number_with_delimiter(count)) : t("savage_beast.topics_count", :count => number_with_delimiter(count))
    end

    def show_mods
      { :onmouseover => "$('topic_mod').show();", :onmouseout => "$('topic_mod').hide();" } if logged_in?
    end

    def ajax_spinner_for(id, spinner="spinner.gif")
      "<img src='/plugin_assets/savage-beast/images/#{spinner}' style='display:none; vertical-align:middle;' id='#{id.to_s}_spinner'> "
    end

    def avatar_for(user, size=32)
      begin
        image_tag "http://www.gravatar.com/avatar.php?gravatar_id=#{MD5.md5(user.email)}&rating=PG&size=#{size}", :size => "#{size}x#{size}", :class => 'photo'
      rescue
        image_tag "http://www.gravatar.com/avatar.php?rating=PG&size=#{size}", :size => "#{size}x#{size}", :class => 'photo'
      end
    end

    def beast_user_name
      (current_user.respond_to?(:display_name) ? current_user.display_name : current_user ? current_user.to_s : "Guest" )
    end

    def beast_user_link
      user_link = (current_user ? current_user : "#")
      link_to beast_user_name, user_link
    end

    def feed_icon_tag(title, url)
      (@feed_icons ||= []) << { :url => url, :title => title }
      link_to image_tag('savage_beast/feed-icon.png', :size => '14x14', :style => 'margin-right:5px', :alt => "Subscribe to #{title}"), url
    end

    def search_posts_title
      returning(params[:q].blank? ? t('savage_beast.recent_posts') : t("savage_beast.searching_for") + " '#{h params[:q]}'") do |title|
        title << " "+'by {user}'[:by_user,h(User.find(params[:user_id]).display_name)] if params[:user_id]
        title << " "+'in {forum}'[:in_forum,h(Forum.find(params[:forum_id]).name)] if params[:forum_id]
      end
    end

    def topic_title_link(topic, options)
      if topic.title =~ /^\[([^\]]{1,15})\]((\s+)\w+.*)/
        "<span class='flag'>#{$1}</span>" +
        link_to(h($2.strip), forums_forum_topic_path(@forum, topic), options)
      else
        link_to(h(topic.title), forums_forum_topic_path(@forum, topic), options)
      end
    end

    def search_posts_path(rss = false)
      options = params[:q].blank? ? {} : {:q => params[:q]}
      options[:format] = 'rss' if rss
      [[:user, :user_id], [:forum, :forum_id]].each do |(route_key, param_key)|
        return send("#{route_key}_posts_path", options.update(param_key => params[param_key])) if params[param_key]
      end
      options[:q] ? search_all_posts_path(options) : send("all_posts_path", options)
    end

  end
end
