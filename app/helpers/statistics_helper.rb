module StatisticsHelper
  
  def render_progress_icon(seen)
    css_class = case seen
    when 0..13 then "cry"
    when 14..27 then "mad"
    when 28..41 then "sad"
    when 42..55 then "neutral"
    when 56..69 then "smile"
    when 70..83 then "grin"
    when 84..100 then "cool"
    end
    return content_tag(:div, nil, :class => css_class)
  end
  
  def elapsed_time(log)
    distance_of_time_in_words(log.created_at, log.updated_at)
  end
  
end