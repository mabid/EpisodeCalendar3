module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def meta(show_overview)
    show_overview.blank? ? nil : content_for(:meta) { show_overview }
  end

  def body_class(css_class)
    content_for(:body_class) { css_class }
  end

  def share_url(url)
    content_for(:share_url) { url }
  end

  def share_title(title)
    content_for(:share_title) { title }
  end
  
	def icon_tag(sprite, size=16)
		return image_tag("pixel.gif", :class => "icon #{sprite}", :alt => "", :height => size, :width => size)
	end
	
	def render_special_flash(prefix)
		result = ""
		flash.each do |key, msg|
		  result += content_tag(:div, msg, :id => key.to_s.gsub("#{prefix}_", "")) if key.to_s.include? prefix
		end
		return result
	end
	
	def build_tag_cloud(tag_cloud, style_list)
		tag_cloud.sort!{ |x,y| x.permalink <=> y.permalink }
		max, min = 0, 0
		tag_cloud.each do |tag|
			max = tag.followers.to_i if tag.followers.to_i > max
			min = tag.followers.to_i if tag.followers.to_i < min
		end
		
		divisor = ((max - min) / style_list.size) + 1
		
		html = ""
		tag_cloud.each do |tag|
			name = tag.name.gsub('&','&amp;').gsub(' ','&nbsp;')
      style = style_list[(tag.followers.to_i - min) / divisor]
      link = "<a href='#{show_path(tag.permalink)}' class='#{style}'>#{name}</a>"
			html += "<li>#{link}</li> "
		end
		return html
	end
	
	def is_current?(controller, action, id = nil)
	  if !id.blank?
	    if !params[:username].blank?
	      "active" if params[:controller].eql?(controller.to_s) && params[:action].eql?(action.to_s) && params[:username].eql?(id.to_s)
	    else
	      "active" if params[:controller].eql?(controller.to_s) && params[:action].eql?(action.to_s) && params[:id].eql?(id.to_s)
	    end
	elsif action.blank?
		"active" if params[:controller].include?(controller.to_s)
	else
		"active" if params[:controller].eql?(controller.to_s) && params[:action].eql?(action.to_s)
	end
  end

  def find_named_routes
    routes = []
   
    Rails.application.routes.named_routes.each do |name, route|
      req = route.requirements
      if req[:controller] == params[:controller] && req[:action] == params[:action]
        routes << name
      end
    end
   
    routes
  end

end