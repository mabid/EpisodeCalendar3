namespace :db do
  desc "Erase and fill database"
  task :update_episodes => :environment do
    
    #We need some libs 
    require "hpricot"
    require "yaml"
    require "open-uri"

    #Create note
    log = Log.create(:key => "episodes_updated")

    #Get API key
    thetvdb = YAML::load(File.open("config/thetvdb.yml"))
    API_KEY = thetvdb["api_key"]
    $EPISODE_API_URL = thetvdb["episode_url"].gsub("<api_key>", API_KEY)
    
    #Go through all episodes
    queued_episodes = UpdateQueue.episodes
    queued_episodes.each do |queued_episode|      
      begin

        #Open URL
        episode_url = $EPISODE_API_URL.gsub("<episode_id>", queued_episode.api_id.to_s)
        puts "Reading: #{episode_url}..."
        doc = Hpricot.parse(open(episode_url))
        row = (doc/"episode")
        
        #Check fauly data
        if (row/"episodename").innerHTML.blank? || (row/"firstaired").innerHTML.blank?
          UpdateQueue.delete(queued_episode.id)
          next
        end
        
        #Create new season if this episode's season doesn't exist
        season_number = (row/"seasonnumber").innerHTML.to_i
        api_show_id = (row/"seriesid").innerHTML.to_i
        season = Season.find_or_create_by_number_and_api_show_id(:number => season_number, :api_show_id => api_show_id)
        
        #Update episode record
        show = Show.find_by_api_show_id(api_show_id)
        unless show
          UpdateQueue.find_or_create_by_api_id_and_update_type(:api_id => api_show_id, :update_type => "show")
        else
          episode = Episode.find_by_api_episode_id(queued_episode.api_id)
          unless episode
            episode = show.episodes.create(:show => show)
            show.update_attributes(:episodes_count => show.episodes_count + 1)
          end
          episode.update_attributes(
            :api_episode_id => (row/"id").innerHTML.to_i,
            :name => (row/"episodename").innerHTML,
            :season_id => season.id,
            :season_number => season_number,
            :number => (row/"episodenumber").innerHTML,
            :overview => (row/"overview").innerHTML,
            :air_date => (row/"firstaired").innerHTML,
            :rating => (row/"rating").innerHTML,
            :api_updated_at => (row/"lastupdated").innerHTML
            )
        end
        UpdateQueue.delete(queued_episode.id)
        
      rescue Exception => ex
        Log.create(:key => "update_episodes_error", :value => queued_episode.api_id, :additional_data => ex.message)
      end
    end

    #Update note
    log.update_attributes(:value => queued_episodes.size, :additional_data => queued_episodes.collect(&:api_id).join(","))      
    
  end
end
