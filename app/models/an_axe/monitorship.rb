module AnAxe
  class Monitorship < ActiveRecord::Base

    belongs_to :topic
    def user
      self.send(AnAxe::Config.user_relation)
    end

  end
end
