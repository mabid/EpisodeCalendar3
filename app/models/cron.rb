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
    
  scope :queue_update, where(:title => "Queue update")
  scope :episodes_update, where(:title => "Episodes update")
  scope :shows_update, where(:title => "Shows update")
  scope :full_show_update, where(:title => "Full show update")
  scope :banners_update, where(:title => "Banners update")
  scope :trends_update, where(:title => "Trends update")
  scope :send_emails, where(:title => "Send emails")
  
  def run_interval
    if every.present?
      eval("#{every}.#{interval}")
    else
      eval("#{interval}")
    end
  end
  
  def time
    am_pm.blank? ? at : "#{at}:00#{am_pm}"
  end
  
  def cmd
    "#{command_type} \"#{command}\""
  end
  
  def humanize
    default = "every #{every} #{interval.pluralize}"
    case interval
      when "hour" then every > 1 ? default : "hourly"
      when "week" then every > 1 ? default : "weekly"
      when "day" then every > 1 ? default : "daily"
      else default
    end
  end
  
  def normalized
    every > 1 ? "#{every} #{interval.pluralize}" : "#{every} #{interval}"
  end
  
end

