class Faq < ActiveRecord::Base  
  scope :important, where(:important => true)
  scope :unimportant, where(:important => false)
  scope :position_lo, where(:position => 0)
  scope :position_mid, where(:position => 1)
  scope :position_hi, where(:position => 2)
  scope :recently_asked, where("created_at > ?", 5.days.ago)
  
  attr_accessible :question, :answer, :position, :important
  
  validates_inclusion_of :position, :in => 0..2
end
