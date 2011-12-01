class Faq < ActiveRecord::Base  
  scope :important, where(:important => true)
  scope :unimportant, where(:important => false)
  scope :recently_asked, where("created_at > ?", 5.days.ago)
  
  attr_accessible :question, :answer, :position, :important
end
