namespace :db do
  desc "Erase and fill database"
  task :update_shows => :environment do
    
    #We need some libs
    require "hpricot"
    require "yaml"
    require "open-uri"

    #Create note
    log = Log.create(:key => "shows_updated")

    #Get API key
    thetvdb = YAML::load(File.open("config/thetvdb.yml"))
    API_KEY = thetvdb["api_key"]
    $SHOW_API_URL = thetvdb["show_url"].gsub("<api_key>", API_KEY)
    
    #Go through all shows
    queued_shows = UpdateQueue.shows
    queued_shows.each do |queued_show|
      begin

        #Open URL
        show_url = $SHOW_API_URL.gsub("<show_id>", queued_show.api_id.to_s)
        puts "Reading: #{show_url}..."
        doc = Hpricot.parse(open(show_url))
        row = (doc/"series")
        
        #Check fauly data
        if (row/"seriesname").innerHTML.blank?
          UpdateQueue.delete(queued_show.id)
          next
        end
        
        #Update show record
        show = Show.find_by_api_show_id(queued_show.api_id)
        unless show
          UpdateQueue.create(:api_id => queued_show.api_id, :update_type => "all_episodes")
          UpdateQueue.create(:api_id => queued_show.api_id, :update_type => "banner")
          show = Show.new
        else
          UpdateQueue.find_or_create_by_api_id_and_update_type(:api_id => queued_show.api_id, :update_type => "banner") if show.banners.empty?
        end
        status = (row/"status").innerHTML.blank? ? "Ended" : (row/"status").innerHTML
        show.update_attributes(
          :api_show_id => (row/"id").innerHTML.to_i,
          :api_updated_at => (row/"lastupdated").innerHTML,
          :name => (row/"seriesname").innerHTML.gsub("&amp;", "&"),
          :overview => (row/"overview").innerHTML.gsub("&amp;", "&"),
          :status => status,
          :first_aired => (row/"firstaired").innerHTML,
          :air_time_hour => (row/"airs_time").innerHTML,
          :day_of_week => day_of_week_to_i((row/"airs_dayofweek").innerHTML),
          :runtime => (row/"runtime").innerHTML,
          :rating => (row/"rating").innerHTML,
          :network => (row/"network").innerHTML,
          :imdb_id => (row/"imdb_id").innerHTML
          )
        UpdateQueue.delete(queued_show.id)
    
      rescue Exception => ex
        Log.create(:key => "update_shows_error", :value => queued_show.api_id, :additional_data => ex.message)
      end
    end
    
    #Update note
    log.update_attributes(:value => queued_shows.size, :additional_data => queued_shows.collect(&:api_id).join(","))
    
  end
end

def day_of_week_to_i(day_string)
  return day_string.downcase.include?("daily") ? -1 : Date::DAYNAMES.index(day_string.capitalize)
end