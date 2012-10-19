# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Episodecalendar2::Application.initialize!

HOST = ENV['RAILS_ENV'] == "development" ? "http://localhost:3000" : "http://www.episodecalendar.com"
DOMAIN = "http://www.episodecalendar.com"

Time::DATE_FORMATS[:air_date] = "%Y%m%d"
Time::DATE_FORMATS[:title_date] = "%B %Y"