# Include hook code here
require File.dirname(__FILE__) + '/lib/acts_as_mail_balancer'

config = YAML.load_file("#{Rails.root}/vendor/plugins/acts_as_mail_balancer/config/mails.yml")
MailBalancerObserver.configure(config[Rails.env])

