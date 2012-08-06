module AnAxe
  class Moderatorship < ActiveRecord::Base

    belongs_to :forum

    before_create { |r| count(:id, :conditions => ['forum_id = ? and user_id = ?', r.forum_id, r.user_id]).zero? }

  end
end
