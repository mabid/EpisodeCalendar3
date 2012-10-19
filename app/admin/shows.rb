ActiveAdmin.register Show do
  
  scope :all, :default => true
  scope :popular
  scope :active
  scope :ended
  
  filter :name
  
  index do

    column :name, :sortable => :name do |show|
      link_to show.name, admin_show_path(show)
    end
    column :status, :sortable => :status do |show|
      if show.ended?
        icon_tag("cross")
      else
        icon_tag("tick")
      end
    end    
    column "Started", :first_aired
    column "Day", :day_of_week, :sortable => :day_of_week do |show|
      unless show.day_of_week.blank?
        day = show.day_of_week
        day = 0 if day == 7
        day == -1 ? "Daily" : "#{Date::DAYNAMES[day]}s"
      end
    end
    column :runtime
    column :network
    column :followers
    column "Trend position", :current_trend_position
    column "Seasons", :seasons_count
    column "Episodes", :episodes_count
    column "" do |show|
      raw "#{link_to "Edit", edit_admin_show_path(show), :class => :member_link} #{link_to "Delete", admin_show_path(show), :class => :member_link, :method => :delete, :confirm => "Delete #{show.name}?"}" 
    end
  end
  
end
