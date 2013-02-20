namespace :db do
  desc "Erase and fill database"
  task :delete_legacy_episodes => :environment do

    seen_counter = 0
    hidden_counter = 0
    

    @invalid_episodes = UpdateQueue.episodes_for_deletion
    @invalid_episodes.each do |queued_episode|
      invalid_episode = Episode.find_by_api_episode_id(queued_episode.api_id)

      #Seen episodes
      @seen = SeenEpisode.find_all_by_episode_id(invalid_episode.id)
      puts "Episode[#{invalid_episode.id}] has been marked #{@seen.size} times."
      if @seen.any?
        seen_counter += 1
        #Remove the marked episode, and decrement the cache column
        @seen.each do |seen|
          puts "Updating marked cache column for user[#{seen.user_id}]"
          #Cache column
          following = Following.find_by_user_id_and_show_id(seen.user_id, invalid_episode.show_id)
          Following.decrement_counter(:marked_episodes_count, following.id) if following
          puts "Decrementing marked counter!"
          #Delete seen record
          SeenEpisode.delete(seen.id)
          puts "Deleting seen episode!"
        end
      end

      #Hidden episodes
      @hidden = HiddenEpisode.find_all_by_episode_id(invalid_episode.id)
      puts "Episode[#{invalid_episode.id}] has been marked #{@hidden.size} times."
      if @hidden.any?
        hidden_counter += 1
        #Remove the marked episode, and decrement the cache column
        @hidden.each do |hidden|
          puts "Updating hidden cache column for user[#{hidden.user_id}]"
          #Cache column
          following = Following.find_by_user_id_and_show_id(hidden.user_id, invalid_episode.show_id)
          Following.decrement_counter(:hidden_episodes_count, following.id) if following
          puts "Decrementing hidden counter!"
          #Delete hidden record
          HiddenEpisode.delete(hidden.id)
          puts "Deleting hidden episode!"
        end
      end

      #Records deleted and cache columns updated. Safe to delete, and decrement the show's cache column
      Episode.delete(invalid_episode)
      puts "Deleting invalid episode!"

      season = Season.find(invalid_episode.season_id)
      if season
        Season.delete(season) if season.episodes.empty?
      end

      UpdateQueue.delete(queued_episode)

    end
    puts "Found a total of #{@invalid_episodes.size} legacy episodes!"
    puts "..#{seen_counter} of these have been marked."
    puts "..#{hidden_counter} of these have been hidden."

  end
end