ActiveAdmin.register Cron do
  
  config.clear_sidebar_sections!
  
  index do
    column :title
    column :every
    column :interval do |cron|
      "#{cron.interval.humanize}" unless cron.interval.blank?
    end
    column :at
    column "AM / PM", :am_pm do |cron|
      "#{cron.am_pm.upcase}" unless cron.am_pm.blank?
    end
    column :command
    column :command_type
    column "", :sortable => :title do |cron|
      raw "#{link_to "Edit", edit_admin_cron_path(cron), :class => :member_link} #{link_to "Delete", admin_cron_path(cron), :class => :member_link, :method => :delete, :confirm => "Delete #{cron.title}?"}" 
    end
  end
  
end
