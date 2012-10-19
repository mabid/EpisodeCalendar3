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

  def minutes_ago_in_words(minutes)
    parts = []

    if minutes > 0
      time = minutes
      time /= 60                # Get rid of minutes
      hours = time % 24         # Extract hours
      time /= 24                # Get rid of hours
      days = time % 30          # Extract days
      time /= 30                # Get rid of days
      months = time             # Months

      { :month => months, :day => days, :hour => hours }.each do |key, val|
        parts << "#{pluralize(val, key.to_s)}" if val > 0
      end
    else
      parts << "0 minutes"
    end

    parts.to_sentence(:last_word_connector => " and ")
  end
  
end