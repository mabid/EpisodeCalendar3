namespace :db do
  desc "Erase and fill database"
  task :fix_shows_followers_count => :environment do

    counter = 0

    Show.all.each do |show|
      print "#{counter}.." if counter%100 == 0
      followers = Following.find_all_by_show_id(show.id)      
      Show.update_counters show.id, :followers => followers.size
      counter += 1
    end
    print "#{counter}!"

  end
end