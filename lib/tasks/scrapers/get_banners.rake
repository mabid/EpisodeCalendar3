namespace :db do
  desc "Erase and fill database"
  task :get_banners => :environment do
    
    #We need some libs
    require "hpricot"
    require "yaml"
    require "open-uri"
    require "net/http"

    #Create note
    log = Log.create(:key => "banners_updated")

    begin

      #Get API key
      thetvdb = YAML::load(File.open("config/thetvdb.yml"))
      API_KEY = thetvdb["api_key"]
      $SHOW_BANNER_API_URL = thetvdb["banner_url"].gsub("<api_key>", API_KEY)
      
      #Go through all shows
      queued_shows = UpdateQueue.show_banners
      queued_shows.each do |queued_show|
  
        begin
          
          #Do we need banner?
          show = Show.find_by_api_show_id(queued_show.api_id)
          puts "#{show.name} has #{show.banners.size} banners"
          unless show.banners.any?
    
            #Open URL
            show_banner_url = $SHOW_BANNER_API_URL.gsub("<show_id>", queued_show.api_id.to_s)
            puts "Reading: #{show_banner_url}..."
            doc = Hpricot.parse(open(show_banner_url))
            banners = (doc/"banner")
            
            #Go through all episodes for this season
            puts "Found #{banners.size} banners!"
            banners.each_with_index do |row, index|
              #Check fauly data
              # - return if name, air_date, season_number or number is blank
              
              #Create new season if this episode's season doesn't exist
              banner_path = (row/"bannerpath").innerHTML
              banner_type = (row/"bannertype").innerHTML
              banner_type2 = (row/"bannertype2").innerHTML
              language = (row/"language").innerHTML
              
              next unless banner_type.downcase == "series" && banner_type2.downcase == "graphical" && (language.downcase == "en" || language.blank?)
      
              #Update episode record
              file_name = banner_path.split("/").last
              banner_url = "/banners/#{banner_path}"
              Net::HTTP.start("thetvdb.com") { |http|
                resp = http.get(banner_url)
                open("tmp/banners/#{file_name}", "wb") { |file| file.write(resp.body) }
              }
              banner = Banner.find_or_create_by_show_id_and_image_file_name(:show_id => show.id, :image_file_name => file_name)
              #Paperclip
              file_path = "tmp/banners/#{file_name}" 
              banner_file = File.new(file_path)
              banner.image = banner_file
              banner.save(false)
              banner_file.close()
              File.delete(file_path)
              
              #Exit. Only save first
              break
              
            end #banners.each
          
          end #unless show.banners.any?

        rescue Exception => ex
          puts ex.message
        end
                  
        queued_show.destroy
      end
          
      #Update note
      log.update_attributes(:value => queued_shows.size)
    
    rescue Exception => ex
      log.update_attributes(:additional_data => ex.message)
    end
    
  end
end

def day_of_week_to_i(day_string)
  return day_string.downcase.include?("daily") ? -1 : Date::DAYNAMES.index(day_string.capitalize)
end