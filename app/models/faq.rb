class Faq < ActiveRecord::Base
  
  default_scope order("position asc, created_at asc")
  scope :important, where(:important => true).order("position ASC")
  
  attr_accessible :question, :answer, :position, :important
  
end
