namespace :db do
  desc "Erase and fill database"
  task :fix_invalid_episode_dates => :environment do

    counter = 0

    @invalid_episodes = Episode.where("air_date LIKE ?", "%22:00:00%").all
    puts "Found a total of #{@invalid_episodes.size} invalid episodes!"
    @invalid_episodes.each do |invalid_episode|

      print "#{counter}.." if counter%100 == 0
      counter += 1
      invalid_episode.update_attributes(:air_date => invalid_episode.air_date + 2.hours)

    end
    print "#{counter}!"

  end
end