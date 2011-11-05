# == Schema Information
#
# Table name: crons
#
#  id           :integer(4)      not null, primary key
#  title        :string(255)
#  every        :integer(4)
#  interval     :string(255)
#  at           :integer(4)
#  am_pm        :string(255)
#  command      :text
#  command_type :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Cron < ActiveRecord::Base
  attr_accessible :title, :every, :interval, :at, :am_pm, :command, :command_type
    
  scope :queue_update, :conditions => { :title => "Queue update" }
  scope :episodes_update, :conditions => { :title => "Episodes update" }
  scope :shows_update, :conditions => { :title => "Shows update" }
  scope :full_show_update, :conditions => { :title => "Full show update" }
  scope :banners_update, :conditions => { :title => "Banners update" }
  scope :trends_update, :conditions => { :title => "Trends update" }
  scope :send_emails, :conditions => { :title => "Send emails" }
  
  def run_interval
    eval("#{every}.#{interval}")
  end
  
  def time
    am_pm.blank? ? at : "#{at}:00#{am_pm}"
  end
  
  def cmd
    "#{command_type} \"#{command}\""
  end
  
  def humanize
    default = "every #{every} #{interval.pluralize}"
    #case interval
    #when "hour": every > 1 ? default : "hourly"
    #when "week": every > 1 ? default : "weekly"
    # when "day": every > 1 ? default : "daily"
    # else default
    #end
  end
  
  def normalized
    every > 1 ? "#{every} #{interval.pluralize}" : "#{every} #{interval}"
  end
  
end
