module DateHelper
  
  def format_date(d)
    return d.strftime("%B #{d.day.ordinalize}, %Y") unless d.nil?
  end
  
  def print_date(d)
    return d.strftime("%b. #{d.day.ordinalize}") unless d.nil?
  end
  
  def week_day(i)
    i = 0 if i == 7
    return Date::ABBR_DAYNAMES[i]
  end
  
  def week_day_full(i)
    i = 0 if i == 7
    return "Daily" if i == -1
    return "#{Date::DAYNAMES[i]}s"
  end
  
  def w3c_date(date)
    date.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end
  
  def print_air_start(d)
  end
  
end