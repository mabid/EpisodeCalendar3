# == Schema Information
#
# Table name: seasons
#
#  id             :integer(4)      not null, primary key
#  api_show_id    :integer(4)
#  number         :integer(4)
#  episodes_count :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

class Season < ActiveRecord::Base
  has_many :episodes
  attr_accessible :api_show_id, :number, :episodes_count
  
  def display_name
    number == 0 ? "Extras" : number
  end
  
end

