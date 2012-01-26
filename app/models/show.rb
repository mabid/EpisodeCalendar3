# == Schema Information
#
# Table name: shows
#
#  id                                :integer(4)      not null, primary key
#  api_show_id                       :integer(4)
#  name                              :string(255)
#  permalink                         :string(255)
#  overview                          :text
#  status                            :string(255)
#  first_aired                       :datetime
#  air_time_hour                     :integer(4)      default(0)
#  day_of_week                       :integer(4)
#  runtime                           :integer(4)      default(0)
#  network                           :string(255)
#  imdb_id                           :string(255)
#  followers                         :integer(4)      default(0)
#  current_trend_position            :integer(4)
#  previous_trend_position           :integer(4)
#  previous_trend_position_followers :integer(4)
#  seasons_count                     :integer(4)      default(0)
#  episodes_count                    :integer(4)      default(0)
#  api_updated_at                    :integer(4)
#  created_at                        :datetime
#  updated_at                        :datetime
#

class Show < ActiveRecord::Base

  has_permalink :name, :unique => true
  attr_accessible :name, :api_show_id, :status, :first_aired, :network, :runtime, :overview, :api_updated_at,
  :day_of_week, :air_time_hour, :imdb_id, :current_trend_position, :previous_trend_position, :seasons_count, :episodes_count, :followers, :permalink
  
	has_many :followings, :dependent => :destroy
	has_many :episodes, :dependent => :destroy
	has_many :banners
	
  scope :popular, where("followers > 0").order("followers DESC, updated_at DESC")
  scope :active, where(:status => 'continuing').order("name ASC")
  scope :ended, where(:status => 'ended').order("name ASC")

  #def to_param
	#	permalink
  #end
  
  #Find shows by letter
  def self.find_by_letter(letter)
    scope = (letter == "0-9") ? self.where("name < ?", "a") : self.where("name LIKE ?", "#{letter}%")
    scope.order("name asc")
  end
  
  def ended?
    self.status.downcase == "continuing" ? false : true
  end
  
  def air_time
    parts = []
    parts << week_day_full(self.day_of_week) unless self.day_of_week.blank?
    parts << show.air_time_hour unless self.air_time_hour.blank?
    parts.join(" ")
  end

	def prev_episode(offset = 0.days)
    Episode.where("show_id = ? AND air_date < ?", self.id, ($TODAY - offset).beginning_of_day).order("air_date desc, number desc").first
	end

	def next_episode(offset = 0.days)
    Episode.where("show_id = ? AND air_date >= ?", self.id, ($TODAY - offset).beginning_of_day).order("air_date asc, number asc").first
	end
	
  def banner(size = nil)
    show_banners = banners
    if show_banners.any?
      if size
        show_banners.first.image.url(size)
      else
        show_banners.first.image.url
      end
    end
  end
  
  def source_url
    "http://www.thetvdb.com/?tab=series&id=#{api_show_id}"
  end

  def popular?
    self.followers > 100
  end
  
end
