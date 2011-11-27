module DateHelper
  
  def format_date(d)
    d.strftime("%B #{d.day.ordinalize}, %Y") unless d.blank?
  end
  
  def print_date(d)
    d.strftime("%b. #{d.day.ordinalize}") unless d.blank?
  end
  
  def week_day(i)
    i = 0 if i == 7
    Date::ABBR_DAYNAMES[i]
  end
  
  def week_day_full(i)
    i = 0 if i == 7
    i == -1 ? "Daily" : "#{Date::DAYNAMES[i]}s"
  end
  
  def w3c_date(date)
    date.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end
  
  def print_air_start(d)
    if d.blank?
      content_tag(:em, "Unknown")
    else
      d.strftime("%B %Y") unless d.nil?
    end
  end
  
end