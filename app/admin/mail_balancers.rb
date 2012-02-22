ActiveAdmin.register MailBalancer do
  menu :label => "Email statistics"
  
  index do
    column :username
    column :usage_count
    column :date
  end
    
end