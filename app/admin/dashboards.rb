ActiveAdmin::Dashboards.build do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  
  section "Number of registered users the last 30 days, day by day", :priority => 1 do
    start_date = Date.today - 1.month
    end_date = Date.today
    user_count = User.count
    users_by_day = users_chart_series(start_date)
    avg = (users_by_day.sum / users_by_day.size).round
    div do
      render "registrations", :user_count => user_count, :users_by_day => users_by_day, :start_date => start_date, :end_date => end_date, :avg => avg
    end
  end
  
  section "Registered users - This month vs. last month", :priority => 2 do
    z = 2.hours
    @users_last_month = User.where("created_at BETWEEN ? AND ?", 1.month.ago.beginning_of_month+z, 1.month.ago.end_of_month+z).size
    @users_this_month = User.where("created_at BETWEEN ? AND ?", Date.today.beginning_of_month.beginning_of_day, Date.today.end_of_month.end_of_day).size
    
    @users_last_week = User.where("created_at BETWEEN ? AND ?", 1.week.ago.beginning_of_week+z, 1.week.ago.end_of_week+z).size
    @users_this_week = User.where("created_at BETWEEN ? AND ?", Date.today.beginning_of_week.beginning_of_day, Date.today.end_of_week.end_of_day).size
    div do
      render "users_month", :users_last_month => @users_last_month, :users_this_month => @users_this_month, :users_last_week => @users_last_week, :users_this_week => @users_this_week
    end
  end
  
  section "Number of seen episodes the last 30 days, day by day", :priority => 3 do
    start_date = Date.today - 1.month
    end_date = Date.today
    arr = Statistic.where(:key => "seen_episodes", :created_at => start_date.beginning_of_day..Time.now.end_of_day)

    if arr.any?
      seen_episodes_by_day_value = arr.map do |episode|
        episode && episode.value.to_f || 0
      end
      seen_episodes_by_day_increase = arr.map do |episode|
        episode && episode.additional_data.to_f || 0
      end
      seen_episodes_by_day_increase.shift

      sum = seen_episodes_by_day_increase.sum
      avg = sum > 0 ? (sum / seen_episodes_by_day_increase.size).round : 0
      seen_episodes_count = arr.last.value
      div do
        render "seen_episodes", :seen_episodes_count => seen_episodes_count, :seen_episodes_by_day_value => seen_episodes_by_day_value, :seen_episodes_by_day_increase => seen_episodes_by_day_increase, :start_date => start_date, :end_date => end_date, :sum => sum, :avg => avg
      end
    end
  end

end