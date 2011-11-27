module CalendarHelper
  	
  def get_cell_css_class(cell_date, current, now)
  	if cell_date.to_s(:air_date) == now.to_s(:air_date)
			return "calendar_today"
		elsif cell_date.month == current.month
			return "calendar_day"
		else
			return "calendar_day_other_month"
		end
	end
  
	def print_calendar_episode(e, user = current_user)
	  #show link
	  url = "/show/#{e.show_permalink}"
	  html = "<strong>#{link_to e.show_name, url, :class => "alternative" + (e.number.to_i == 1 ? " premiere" : "") }</strong>"
	  
	  #get formats
	  show_format = (user.nil? ? 1 : user.show_format)
	  episode_format  = (user.nil? ? 1 : user.episode_format)
	  
	  #concat html
		case show_format
  		when 1 ; html += "<span rel=\"tip_#{e.id}\" class=\"tip\">: #{e.format(episode_format)} </span> "
  		when 2..3 ; html += "<br /><span rel=\"tip_#{e.id}\" class=\"tip\">#{e.name} (#{e.format(episode_format)})</span> "
		end
    return html
	end
	
	def print_iframe_calendar_episode(e, user = current_user)
	  #show name
	  html = "<strong>#{e.show_name}</strong>"
	  
	  #get formats
	  show_format = (user.nil? ? 1 : user.show_format)
	  episode_format  = (user.nil? ? 1 : user.episode_format)
	  
	  #concat html
		case show_format
  		when 1 ; html += "<span rel=\"tip_#{e.id}\" class=\"tip\">: #{e.format(episode_format)} </span>"
  		when 2..3 ; html += "<br /><span rel=\"tip_#{e.id}\" class=\"tip\">#{e.name} (#{e.format(episode_format)})</span>"
		end
    return html
	end
	
end