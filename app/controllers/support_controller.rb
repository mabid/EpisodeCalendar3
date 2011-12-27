class SupportController < ApplicationController
  
  #We need some libs
  require "hpricot"
  require "yaml"
  require "open-uri"
  require 'uri'
  require 'net/https'

  def index
    unless @ticket = flash[:ticket]
      @ticket = Ticket.new
    end
  end
  
  def request_show
    @shows = []
    google_plus_url = "https://plusone.google.com/u/0/_/+1/fastbutton?url=#{u(DOMAIN)}&count=true"
    result = RestClient.get(google_plus_url)
    google_plus_doc = Hpricot.parse(result)
    @count = google_plus_doc.search("div[@id=aggregateCount]").innerHTML

    unless params[:query].blank?
            
      #Get API url
      thetvdb = YAML::load(File.open("config/thetvdb.yml"))
      query_url = thetvdb["search_url"].gsub("<query>", params[:query].gsub(" ", "+"))
      @banner_image_url = thetvdb["banner_image"]
      
      doc = Hpricot.parse(open(query_url))
      (doc/"series").each do |row|
        date_string = (row/"firstaired").innerHTML
        date = date_string.blank? ? nil : Date.parse(date_string)
        id = (row/"id").innerHTML
        @shows << { :id => id,
                    :name => (row/"seriesname").innerHTML,
                    :first_aired => date,
                    :overview => (row/"overview").innerHTML,
                    :banner => (row/"banner").innerHTML,
                    :exists => Show.find_by_api_show_id(id)
                   }
      end

    end
  end
  
  def queue_requested_show
    @show = Show.create(:api_show_id => params[:show_id], :name => params[:show_name], :status => "Continuing", :air_time_hour => nil)
    UpdateQueue.find_or_create_by_api_id(:api_id => @show.api_show_id, :update_type => "show")
    Log.create(:key => "show_requested", :value => @show.name)
    redirect_to(request_successful_path(@show.permalink))
  end
  
  def request_successful
    @show = Show.find_by_permalink(params[:permalink])
  end
  
end