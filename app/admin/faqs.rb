ActiveAdmin.register Faq do
  menu :label => "FAQs"
  
  config.clear_sidebar_sections!
  
  index do
    column :id
    column :question, :sortable => false do |faq|
      link_to faq.question, admin_faq_path(faq)
    end
    column :answer do |faq|
      truncate(faq.answer, :length => 50)
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
      raw "#{link_to "Edit", edit_admin_faq_path(faq), :class => :member_link} #{link_to "Delete", admin_faq_path(faq), :class => :member_link, :method => :delete, :confirm => "Delete question '#{faq.question}'?"}" + icon_tag("drag_handle")
    end
  end

  form do |f|
    size = Faq.all.size
    f.inputs do
      f.input :question
      f.input :answer
      if f.object.new_record?
        f.input :position, :input_html => { :value => size + 1 }
      else
        f.input :position
      end
      f.input :important
      f.buttons
    end
  end
    
end