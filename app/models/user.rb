# == Schema Information
#
# Table name: users
#
#  id                         :integer(4)      not null, primary key
#  name                       :string(255)
#  email                      :string(255)
#  encrypted_password         :string(40)
#  password_salt              :string(40)
#  created_at                 :datetime
#  updated_at                 :datetime
#  remember_token             :string(255)
#  remember_created_at        :datetime
#  confirmation_token         :string(40)
#  confirmed_at               :datetime
#  show_format                :integer(4)      default(1)
#  episode_format             :integer(4)      default(1)
#  reset_password_token       :string(255)
#  admin                      :boolean(1)      default(FALSE)
#  followings_count           :integer(4)      default(0)
#  time_zone                  :string(255)     default("UTC")
#  sun_to_sat                 :boolean(1)      default(FALSE)
#  daily_notification         :boolean(1)      default(FALSE)
#  weekly_notification        :boolean(1)      default(FALSE)
#  only_premiere_notification :boolean(1)      default(FALSE)
#  hide_profile               :boolean(1)      default(FALSE)
#  hide_overview_in_rss       :boolean(1)      default(FALSE)
#  authentication_token       :string(255)
#  confirmation_sent_at       :datetime
#  sign_in_count              :integer(4)      default(0)
#  current_sign_in_at         :datetime
#  last_sign_in_at            :datetime
#  current_sign_in_ip         :string(255)
#  last_sign_in_ip            :string(255)
#  day_offset                 :integer(4)      default(0)
#

class User < ActiveRecord::Base
  include Gravtastic
  
  has_many :followings, :dependent => :destroy
  has_many :shows, :through => :followings
  has_many :seen_episodes
  
  scope :nameless, where("name IS NULL or name = ''")
  scope :active, where("daily_notification = true")
  scope :inactive, where("daily_notification = true")
  scope :no_shows, where("followings_count = 0")
  scope :daily_notification, where("daily_notification = true")
  scope :weekly_notification, where("weekly_notification = true")
  scope :only_premiere_notification, where("only_premiere_notification = true")
  
	gravtastic :filetype => :jpg, :size => 64, :default => "http://www.episodecalendar.com/images/pixel.gif?1"  
  devise :database_authenticatable, :encryptable, :registerable, :recoverable, :rememberable, :validatable, :trackable
  
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :sun_to_sat, :time_zone, :hide_overview_in_rss, :hide_profile,
                  :daily_notification, :weekly_notification, :only_premiere_notification, :show_format, :episode_format, :day_offset

  def self.find_by_letter(letter)
    if letter == "0-9"
      self.where("name < ?", "a")
    else
      self.where("name LIKE ?", "#{letter}%")
    end
  end
  
  #Large gravtastic
  def gravatar_size(size)
    self.gravatar_url.gsub(/s=\d+/, "s=#{size}")
  end
  
	def is_following(show)
		Following.exists?({:user_id => self, :show_id => show.id})
	end
	
	def is_admin?
		self.admin == true
	end
	
	def display_name
	  name.blank? ? email : name
  end
	
end
