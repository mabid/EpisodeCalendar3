module UsersHelper
	
	def set_calendar_setting_url(img, show_format, episode_format, user, description)
	  css_class = "setting"
		if user.show_format.eql?(show_format) && user.episode_format.eql?(episode_format)
			content = image_tag("settings/#{img}.jpg")
			css_class += " active"
		else
			url = {:controller => "users", :action => "set_format", :show_format => show_format, :episode_format => episode_format}
			content = link_to(image_tag("settings/#{img}.jpg"), url)
		end
		return content_tag(:div, content + content_tag(:p, description), :class => css_class)
	end
	
	def embed_url(user)
	  "#{HOST}/icalendar/#{user.email}/#{user.password_salt}/?v=light"
  end

  def me?(user)
  	return if current_user.blank?
  	current_user.id == user.id
  end
	
end