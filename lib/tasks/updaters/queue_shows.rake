namespace :db do
  desc "Erase and fill database"
  task :queue_shows => :environment do
    
    counter = 0
    print "Queing all shows: "
    Following.select("distinct(show_id)").each do |following|
      counter += 1
      print "#{counter}.." if counter%100 == 0
      show = following.show
      UpdateQueue.find_or_create_by_api_id_and_update_type(:api_id => show.api_show_id, :update_type => "all_episodes") if show
    end
    print "#{counter}!"
    
  end
end