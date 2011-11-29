class Faq < ActiveRecord::Base
  scope :important, where ("important = true")
  
  attr_accessible :question, :answer, :position, :important
end
