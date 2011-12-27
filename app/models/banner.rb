# == Schema Information
#
# Table name: banners
#
#  id                 :integer(4)      not null, primary key
#  show_id            :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer(4)
#  image_updated_at   :datetime
#

class Banner < ActiveRecord::Base
  belongs_to :show
  attr_accessible :show_id
  
	has_attached_file :image,
    :url => "/assets/uploads/banners/:id/:style_:basename.:extension",
    :path => ":rails_root/assets/images/uploads/banners/:id/:style_:basename.:extension",
    :styles => {
      :small => "252x86#"
    }
end
