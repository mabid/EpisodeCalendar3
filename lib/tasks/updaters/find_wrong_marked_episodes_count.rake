namespace :db do
  desc "Erase and fill database"
  task :find_wrong_marked_episodes_count => :environment do

    counter = 0
    fixed_counter = 0
    Following.all.each do |following|
      counter += 1
      print "#{counter}.." if counter%10000 == 0
      show = following.show
      season_ids = Season.find_all_by_api_show_id(show.api_show_id).collect(&:id)
      real_seen_episodes = SeenEpisode.find(:all, :conditions => ["user_id = ? AND season_id IN (?)", following.user, season_ids])
      ok = (real_seen_episodes.size == following.marked_episodes_count)
      unless ok
        puts "(#{following.user.email}) [#{show.name}] Seen count says #{following.marked_episodes_count} - Real count is #{real_seen_episodes.size}"
        following.update_attributes(:marked_episodes_count => real_seen_episodes.size)
        fixed_counter += 1
      end
    end
    puts "#{counter}!"
    puts "Fixed #{fixed_counter} record!"
    
  end
end