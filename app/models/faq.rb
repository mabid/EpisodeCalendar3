class Faq < ActiveRecord::Base
  after_initialize :default_values
  
  scope :important, :conditions => "important = true"
  scope :unimportant, :conditions => "not important = true"
  scope :recently_asked, where("created_at > ?", 5.days.ago)
  
  attr_accessible :question, :answer, :position, :important
  
  def important?
    self.important
  end
  
  private
  
  def default_values
    self.position ||= 0
  end
end
