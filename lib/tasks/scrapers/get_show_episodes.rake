namespace :db do
  desc "Erase and fill database"
  task :get_show_episodes => :environment do
    
    #We need some libs
    require "hpricot"
    require "yaml"
    require "open-uri"

    #Create note
    log = Log.create(:key => "shows_updated")

    begin

      #Get API key
      thetvdb = YAML::load(File.open("config/thetvdb.yml"))
      API_KEY = thetvdb["api_key"]
      $SHOW_API_URL = thetvdb["show_with_episodes_url"].gsub("<api_key>", API_KEY)
      
      #Go through all shows
      queued_shows = UpdateQueue.show_episodes
      queued_shows.each do |queued_show|
        #Open URL
        show_url = $SHOW_API_URL.gsub("<show_id>", queued_show.api_id.to_s)
        puts "Reading: #{show_url}..."
        begin
          doc = Hpricot.parse(open(show_url))
          episodes = (doc/"episode")
          episode_ids = []
          
          #Go through all episodes for this season
          puts "Found #{episodes.size} episodes!"
          show = Show.find_by_api_show_id(queued_show.api_id)
          if show
            seasons = []
            episodes.each do |row|
              #Check fauly data
              firstaired = Time.zone.parse((row/"firstaired").innerHTML) rescue nil
              if (row/"episodename").innerHTML.blank? || firstaired.blank?
                puts "episodename or firstaired are empty for episode id: #{(row/"id").innerHTML.to_i}.. skipping!"
                next
              end
              
              #Create new season if this episode's season doesn't exist
              season_number = (row/"seasonnumber").innerHTML.to_i
              api_show_id = (row/"seriesid").innerHTML.to_i
              api_episode_id = (row/"id").innerHTML.to_i
              season = Season.find_or_create_by_number_and_api_show_id(:number => season_number, :api_show_id => api_show_id)
              seasons << season.number
              episode_ids << api_episode_id
              
              #Update episode record
              episode = Episode.find_by_api_episode_id(api_episode_id)
              unless episode
                episode = Episode.new
              end
              episode.update_attributes(
                :show_id => show.id,
                :api_episode_id => api_episode_id,
                :name => (row/"episodename").innerHTML,
                :season_id => season.id,
                :season_number => season_number,
                :number => (row/"episodenumber").innerHTML,
                :overview => (row/"overview").innerHTML,
                :air_date => firstaired,
                :rating => (row/"rating").innerHTML,
                :api_updated_at => (row/"lastupdated").innerHTML
                )
            end
            show.update_attributes(:episodes_count => episode_ids.size)
            show.update_attributes(:seasons_count => seasons.uniq.size)

            #Mark faulty episodes for deletion
            current_episode_ids = Episode.where("show_id = ?", show.id).map(&:api_episode_id)
            episodes_for_delete = current_episode_ids - episode_ids
            episodes_for_delete.each do |api_episode_id|
              UpdateQueue.find_or_create_by_api_id_and_update_type(:api_id => api_episode_id, :update_type => "episode_deletion")
            end

          end
        rescue Exception => ex
          puts ex.message
        end
        
        queued_show.destroy
      end
      
      #Update note
      log.update_attributes(:value => queued_shows.size, :additional_data => queued_shows.collect(&:api_id).join(","))
    
    rescue Exception => ex
      log.update_attributes(:additional_data => ex.message)
    end

  end
end