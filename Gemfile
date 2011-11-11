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
gem "capistrano"
gem "hoptoad_notifier"
gem "whenever"

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

#Racks
gem "activeadmin"

#Email
gem "adzap-ar_mailer"#, :lib => "action_mailer/ar_mailer"
gem "ambethia-smtp-tls"#, :lib => "smtp-tls"

#Devise
gem "devise"
gem "warden"

group :assets do
  gem "sass-rails",   "~> 3.1.4"
  gem "coffee-rails", "~> 3.1.1"
  gem "uglifier", ">= 1.0.3"
end

group :development do
  gem "mongrel", "1.2.0.pre2"
  gem "rails-dev-boost", :git => "git://github.com/thedarkone/rails-dev-boost.git", :require => "rails_development_boost"
  gem "bullet"
end

group :test do
  gem "turn", :require => false
end
