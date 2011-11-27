module FollowingsHelper
  
  def print_unwatched(count)
    if count > 0
	    "<em class=\"green\">#{count} unwatched episodes</em>"
	  else
	    "<em>#{count} unwatched episodes</em>"
    end
  end
  
  def wasted_in_words(to)
    time_hash = Time.diff(Time.now, Time.now + to.minutes)
    wasted = []
    months = time_hash[:month]
    days = time_hash[:day]
    hours = time_hash[:hour]
    wasted << pluralize(months.to_i, "month") if months > 0
    wasted << pluralize(days.to_i, "day") if days > 0
    wasted << pluralize(hours.to_i, "hour") if hours > 0
    unless hours.to_i == 0
      wasted.to_sentence(:last_word_connector => " and ")
    else
      pluralize(time_hash[:minute].to_i, "minute")
    end
  end
  
end