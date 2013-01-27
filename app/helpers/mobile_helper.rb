module MobileHelper

  def m_print_calendar_episode(e, user = current_user)

    #show link
    url = "/show/#{e.show.permalink}"

    #get formats
    show_format = (user.nil? ? 1 : user.show_format)
    episode_format  = (user.nil? ? 1 : user.episode_format)
    
    html = content_tag(:h3, e.show.name, :class => e.number.to_i == 1 ? "premiere" : "")
    case show_format
      when 1 ; html += "<p>#{e.format(episode_format)}</p>".html_safe
      when 2..3 ; html += "<p>#{e.name} (#{e.format(episode_format)})</p>".html_safe
    end
    link = raw link_to html, url, :"data-transition" => "slide"

    return html
  end

end