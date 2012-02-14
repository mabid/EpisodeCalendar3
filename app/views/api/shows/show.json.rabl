object @show
attributes :id, :name, :permalink, :overview, :status, :first_aired, :day_of_week, :runtime, :network, :followers, :seasons_count, :episodes_count, :current_trend_position
node(:url) { |show| show_url(show) }

child :banners do
  node(:large) { |banner| DOMAIN + banner.image.url }
  node(:small) { |banner| DOMAIN + banner.image.url(:small) }
end

child :episodes do
  attributes :id, :name, :season_number, :number, :air_date, :overview
end