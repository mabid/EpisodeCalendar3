ActiveAdmin.register Faq do
  menu :label => "FAQs"
  
  config.clear_sidebar_sections!
  
  index do
    column :id
    column :question, :sortable => false do |faq|
      link_to faq.question, admin_faq_path(faq)
    end
    column :answer
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
      raw "#{link_to "Edit", edit_admin_faq_path(faq), :class => :member_link} #{link_to "Delete", admin_faq_path(faq), :class => :member_link, :method => :delete, :confirm => "Delete question '#{faq.question}'?"}" + content_tag(:span, "[drag]", :class => "drag_handle")
    end
  end
end