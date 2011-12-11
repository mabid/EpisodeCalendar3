def users_chart_series(start_time)
  arr = User.where(:created_at => start_time.beginning_of_day..Time.now.end_of_day).group("date(created_at)").select("created_at, count(created_at) as total")
  (start_time.to_date..Date.today).map do |date|
    user = arr.detect { |user| user.created_at.to_date == date }
    user && user.total.to_f || 0
  end
end