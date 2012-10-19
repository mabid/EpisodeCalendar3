ActiveAdmin.register User do
  
  scope :all, :default => true
  scope :active
  scope :inactive
  scope :no_shows
  scope :nameless
  
  filter :name
  filter :email
  filter :followings_count
  filter :time_zone, :as => :select, :collection => proc { User.group(:time_zone).map(&:time_zone) }
  filter :sun_to_sat
  filter :daily_notification
  filter :weekly_notification
  filter :only_premiere_notification
  filter :hide_overview_in_rss
  filter :sign_in_count

  index do
    column :name, :sortable => :name do |user|
      link_to user.name, admin_user_path(user)
    end
    column :email, :sortable => :email do |user|
      link_to user.email, admin_user_path(user)
    end
    column "Logins", :sign_in_count
    column "Shows", :followings_count
    column :time_zone
    column :day_offset, :sortable => false
    column :sun_to_sat, :sortable => false
    column :created_at
    column "", :sortable => :title do |user|
      raw "#{link_to "Edit", edit_admin_user_path(user), :class => :member_link} #{link_to "Delete", admin_user_path(user), :class => :member_link, :method => :delete, :confirm => "Delete #{user.email}?"}" 
    end
  end
  
  sidebar :statistics do
    div do
      strong "Notifications"
    end
    ul do
      li "Daily: #{User.daily_notification.size}"
      li "Weekly: #{User.weekly_notification.size}"
      li "Premiere only: #{User.only_premiere_notification.size}"
    end
    
    div do
      strong "Misc"
    end
    ul do
      li "Daily notification: #{User.daily_notification.size}"
      li "Weekly notification: #{User.weekly_notification.size}"
      li "Premiere only notification: #{User.only_premiere_notification.size}"
    end
  end

end
