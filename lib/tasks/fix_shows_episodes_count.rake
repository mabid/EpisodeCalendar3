namespace :db do
  desc "Erase and fill database"
  task :fix_shows_episodes_count => :environment do

    counter = 0

    Show.all.each do |show|
      print "#{counter}.." if counter%100 == 0
      episodes = Episode.find_all_by_show_id(show.id)
      show.update_attributes(:episodes_count => episodes.size) if show.episodes_count != episodes.size
      counter += 1
    end
    print "#{counter}!"

  end
end