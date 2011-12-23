module ShowsHelper
  
  def print_episode(episode)
    return "-" unless episode
    s = episode.season_number
    e = episode.number
    return "<strong>#{episode.name}</strong><em>#{format_episode_number(episode)}</em>"
  end
  
  def print_prev_episode(episode, day_offset)
    return "-" unless episode
    
    date = episode.air_date + day_offset
    time_ago = case date.to_s(:air_date)
      when $TODAY.yesterday.to_s(:air_date) ; "Yesterday"
      else "#{time_ago_in_words(date + 1.day)} ago"
    end
    
    return "<strong>#{format_episode_number(episode)} - #{episode.name}</strong><em>#{format_date(date)} | #{time_ago}</em>"
  end

  def print_next_episode(episode, day_offset)
    return "-" unless episode
    
    date = episode.air_date + day_offset
    time_ago = case date.to_s(:air_date)
      when $TODAY.to_s(:air_date) ; "Today"
      when $TODAY.tomorrow.to_s(:air_date) ; "Tomorrow"
      else "#{time_ago_in_words(date + 1.day)} from now"
    end
    
    return "<strong>#{format_episode_number(episode)} - #{episode.name}</strong><em>#{format_date(date)} | #{time_ago}</em>"
  end

  def print_show_status(show)
    if show.ended?
      return icon_tag("icons/big/delete_64.png", :class => :status_icon, :alt => "") + raw('<span class="red">Ended</span>')
    else
      return image_tag("icons/big/accept_64.png", :class => :status_icon, :alt => "") + raw('<span class="green">Still airing</span>')
    end
  end
  
  def print_popularity(show)
    return "<span>Unknown</span>" if show.previous_trend_position_followers.blank?
    dir = show.current_trend_position == show.previous_trend_position ? 0 : (show.current_trend_position > show.previous_trend_position ? 1 : -1)
    diff = show.previous_trend_position - show.current_trend_position
    case dir
      when -1 then "<span class=\"green\">+#{pluralize(diff, "place")}</span>"
      when 0 then "<span class=\"grey\">&plusmn;0</span>"
      when 1 then "<span class=\"red\">#{pluralize(diff, "place")}</span>"
    end
  end
  
  def print_trend(show)
    return if show.followers.blank? || show.previous_trend_position_followers.blank? || show.followers <= 0
    diff = ((show.followers.to_f/show.previous_trend_position_followers)*100-100).round
    return "<span>#{"+" if diff > 0}#{diff}%</span>"
  end
  
  def print_first_aired(date)
    date.blank? ? "Unknown start" : date.strftime("%B %Y")
  end
  
  def print_air_time(show)
    return content_tag(:span, raw("#{icon_tag("cross")} Ended"), :class => "red") if show.ended?
    
    air_time_parts = []
    unless show.day_of_week.blank?
      day_of_week = (current_user ? show.day_of_week + current_user.day_offset : show.day_of_week)
      air_time_parts << week_day_full(day_of_week)
    end
    air_time_parts << "at #{show.air_time_hour}" unless show.air_time_hour.blank?
    air_time = air_time_parts.join(" ")

    output_parts = []
    output_parts << "#{icon_tag("television")} " + show.network unless show.network.blank?
    output_parts << "#{icon_tag("clock")} " + air_time unless air_time.blank?
    return output_parts.join()
  end
  
end