namespace :db do
  desc "Erase and fill database"
  task :fix_marked_episodes_count => :environment do

    counter = 0
    print "Fixing marked episodes count: "
    Following.find(:all, :conditions => "marked_episodes_count > 0").each do |following|
      counter += 1
      print "#{counter}.." if counter%1000 == 0
      show = following.show
      if show
        #get seasons
        season_ids = Season.find_all_by_api_show_id(show.api_show_id).collect(&:id)
        seen_episodes = SeenEpisode.find(:all, :conditions => ["user_id = ? AND season_id IN (?)", following.user, season_ids])
        following.update_attributes(:marked_episodes_count => seen_episodes.size) if following.marked_episodes_count != seen_episodes.size
      end
    end
    print "#{counter}!"
    
  end
end