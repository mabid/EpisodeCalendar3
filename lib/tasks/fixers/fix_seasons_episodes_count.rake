namespace :db do
  desc "Erase and fill database"
  task :fix_seasons_episodes_count => :environment do

    counter = 0

    Season.all.each do |season|
      print "#{counter}.." if counter%100 == 0
      episodes = Episode.find_all_by_season_id(season.id)
      season.update_attributes(:episodes_count => episodes.size) if season.episodes_count != episodes.size
      counter += 1
    end
    print "#{counter}!"

  end
end