collection @shows
attributes :id, :name, :status, :first_aired, :day_of_week, :runtime, :network, :followers, :seasons_count, :episodes_count, :current_trend_position
node(:url) { |show| show_url(show) }