source "http://rubygems.org"
source "http://gemcutter.org/"
source "http://gems.github.com/"

#Main
gem "rails", "3.1.1.rc3"
#gem "rails", :git => "git://github.com/rails/rails.git"

#System
gem "mysql2"
gem "therubyracer", require: "v8"
gem "rack" , "!= 1.3.4"

#Tools
gem "rvm"
gem "capistrano"
gem "capistrano-ext"
gem "whenever"
gem "airbrake"

#Application
gem "jquery-rails"
gem "hpricot"
gem "activerecord-import"
gem "gravtastic"
gem "kaminari"
gem "time_diff"
gem "has_permalink"
gem "paperclip"
gem "icalendar"
gem "amazon_product"
gem "RedCloth"
gem "delayed_job_active_record"
gem "rest-client"
gem "rmagick"
gem "rabl"
gem "thumbs_up"

#Cache
gem "dalli"
gem "cache_fu", :git => "https://github.com/kreetitech/cache_fu.git"

#Racks
gem "activeadmin"

#Devise
gem "devise", "1.5.2"
gem "warden"

#Put Sass outside of the :assets group (ActiveAdmin fix)
gem "sass-rails", "~> 3.1.4"

group :assets do
  gem "coffee-rails", "~> 3.1.1"
  gem "uglifier", ">= 1.0.3"
end

group :development do
  gem "mongrel", "1.2.0.pre2"
  gem "thin"
  gem "rails-dev-tweaks", "~> 0.5.1"
  gem "bullet"
  gem "letter_opener"
  gem "nifty-generators", :group => :development
end

group :test do
  gem "turn", :require => false
end
gem "mocha", :group => :test