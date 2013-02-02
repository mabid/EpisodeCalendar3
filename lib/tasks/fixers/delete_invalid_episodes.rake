namespace :db do
  desc "Erase and fill database"
  task :delete_invalid_episodes => :environment do

    seen_counter = 0
    hidden_counter = 0

    @invalid_episodes = Episode.where("air_date IS NULL").all
    @invalid_episodes.each do |invalid_episode|

      #Mark faulty episodes for deletion
      UpdateQueue.find_or_create_by_api_id_and_update_type(:api_id => invalid_episode.api_episode_id, :update_type => "episode_deletion")

    end
    puts "Found a total of #{@invalid_episodes.size} invalid episodes!"
    puts "..#{seen_counter} of these have been marked."
    puts "..#{hidden_counter} of these have been hidden."

  end
end