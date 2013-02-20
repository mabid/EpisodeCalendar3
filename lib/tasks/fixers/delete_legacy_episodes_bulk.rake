namespace :db do
  desc "Erase and fill database"
  task :delete_invalid_episodes_bulk => :environment do

    seen_counter = 0
    hidden_counter = 0

    @invalid_episodes = UpdateQueue.episodes_for_deletion
    @invalid_episodes.each_with_index do |invalid_episode, index|
      @episode = Episode.find_by_api_episode_id(invalid_episode.api_id)
      if @episode
      print "##{index}: Fixing episode [#{@episode.id}]"
      #Seen episodes
      print " .. seen"
      SeenEpisode.delete_all(["episode_id = ?", @episode.id])

      #Hidden episodes
      print " .. hidden"
      HiddenEpisode.delete_all(["episode_id = ?", @episode.id])

      #Records deleted and cache columns updated. Safe to delete, and decrement the show's cache column

      season = Season.find(@episode.season_id)
      if season
        Season.delete(season) if season.episodes.empty?
      end

      Episode.delete(@episode)
      print " .. deleting episode!\n"
      end

      UpdateQueue.delete(invalid_episode)
    end

  end
end
