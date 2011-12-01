ActiveAdmin.register Faq do
  menu :label => "FAQs"
  
  scope :all, :default => true
  scope :important
  scope :unimportant
  scope :recently_asked
  
  filter :question
  filter :position
  filter :created_at
  
  index do
    column :id
    column :question, :sortable => false do |faq|
      link_to faq.question, admin_faq_path(faq)
    end
    column :answer, :sortable => false do |faq|
      link_to faq.question, admin_faq_path(faq)
    end
    column :position
    column :important, :sortable => false do |faq|
      if faq.important?
        icon_tag("tick")
      else
        icon_tag("cross")
      end
    end
    column :created_at
    column "" do |faq|
      raw "#{link_to "Edit", edit_admin_faq_path(faq), :class => :member_link} #{link_to "Delete", admin_faq_path(faq), :class => :member_link, :method => :delete, :confirm => "Delete question '#{faq.question}'?"}" 
    end
  end
end
