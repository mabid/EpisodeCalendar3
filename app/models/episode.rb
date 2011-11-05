# == Schema Information
#
# Table name: episodes
#
#  id             :integer(4)      not null, primary key
#  show_id        :integer(4)
#  api_episode_id :integer(4)
#  season_id      :integer(4)
#  season_number  :integer(4)
#  number         :integer(4)
#  name           :string(255)
#  air_date       :datetime
#  overview       :text
#  rating         :float
#  api_updated_at :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

class Episode < ActiveRecord::Base
  belongs_to :show
  belongs_to :season
  attr_accessible :show_id, :api_episode_id, :season_id, :season_number, :number, :name, :air_date, :overview, :rating, :api_updated_at
  
  attr_accessor :real_air_date
  
  def friendly_overview(plain = false)
    if self.overview.blank? || self.overview.match(/TBD/) || self.overview.match(/No synopsis available/)
      return plain ? "This episode has no summary." : "<em>This episode has no summary.</em>"
    else
      return self.overview.gsub("&#039;", "'")
    end
  end
  
  def format(format = 1)
    case format
      when 1..2 ; return "%01dx%01d" % [self.season_number, self.number]
      when 3 ; return "s%02de%02d" % [self.season_number, self.number]
    end
  end
  
end
