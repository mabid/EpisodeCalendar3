namespace :db do
  desc "Erase and fill database"
  task :set_users_name => :environment do

    counter = 0

    User.where("name = ? OR name IS NULL", "").each do |user|
      new_name = user.email.split("@")[0]
      user.update_attributes(:name => new_name)
      counter += 1
    end
    print "#{counter}!"

  end
end