class ShowAttributeVote < ActiveRecord::Base
  attr_accessible :show_id, :user_id, :show_attribute, :attribute_value
  belongs_to :show
  belongs_to :user

  acts_as_voteable

  def self.votable_attributes
    [
      ["Air time", "air_time_hour"],
      ["Network", "network"]
    ]
  end

  def self.has_votes_for?(show_id, user, show_attribute)
  	voted = false
  	available_votes = where("show_id = ? AND show_attribute = ?", show_id, show_attribute)
  	available_votes.each do |votable|
  		voted = true if user.voted_on?(votable)
  	end
  	voted  	
  end

end