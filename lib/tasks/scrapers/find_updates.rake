namespace :db do
  desc "Erase and fill database"
  task :find_updates => :environment do
    
    #We need some libs
    require "hpricot"
    require "yaml"
    require "open-uri"
    
    #Create notes
    show_log = Log.create(:key => "shows_queued")
    episode_log = Log.create(:key => "episodes_queued")

    begin

      #Get last update_time
      last_api_update = Constant.find_or_create_by_key(:key => "last_api_update", :value => "1")
  
      #Get API key
      thetvdb = YAML::load(File.open("config/thetvdb.yml"))
      UPDATES_URL = thetvdb["updates_url"].gsub("<time>", last_api_update.value)
      
      #Open URL
      puts "Reading: #{UPDATES_URL}..."
      doc = Hpricot.parse(open(UPDATES_URL))
      
      #Fetch all shows and put in queue
      shows = (doc/:series)
      puts "#{shows.size} shows need an update!"
      shows.each do |show|
        UpdateQueue.find_or_create_by_api_id_and_update_type(:api_id => show.innerHTML, :update_type => "all_episodes")
      end
  
      #Fetch all episodes and put in queue
      episodes = (doc/:episode)
      puts "#{episodes.size} episodes need an update!"
      episodes.each do |episode|
        UpdateQueue.find_or_create_by_api_id_and_update_type(:api_id => episode.innerHTML, :update_type => "episode")
      end
  
      #Fetch new last_api_update and update the current one
      new_last_api_update = (doc/:time)
      unless new_last_api_update.innerHTML.blank?
        last_api_update.update_attributes(:value => new_last_api_update.innerHTML)
      end
          
      #Update note
      show_log.update_attributes(:value => shows.size)
      episode_log.update_attributes(:value => episodes.size)
    
    rescue Exception => ex
      show_log.update_attributes(:additional_data => ex.message)
      episode_log.update_attributes(:additional_data => ex.message)
    end

  end
end