ActiveAdmin.register Constant do
  
  config.clear_sidebar_sections!
  
  scope :all, :default => true
  scope :ticket_categories
  scope :command_types
  scope :mobile_login
  
  index do
    column :key
    column :value
    column :additional_data
    column "", :sortable => :title do |constant|
      raw "#{link_to "Edit", edit_admin_constant_path(constant), :class => :member_link} #{link_to "Delete", admin_constant_path(constant), :class => :member_link, :method => :delete, :confirm => "Delete #{constant.key} (#{constant.value})?"}" 
    end
  end
  
end
