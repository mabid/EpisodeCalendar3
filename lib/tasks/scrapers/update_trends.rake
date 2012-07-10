namespace :db do
  desc "Erase and fill database"
  task :update_trends => :environment do
    
    #Create note
    log = Log.create(:key => "show_trends_updated")

    begin

      shows = Show.popular
      shows.each_with_index do |show, index|
        unless show.current_trend_position.blank?
          show.previous_trend_position = show.current_trend_position
          show.previous_trend_position_followers = show.followers
        end
        show.current_trend_position = index + 1
        show.save(:validate => false)
      end
      
      #Update note
      log.update_attributes(:value => shows.size)
    
    rescue Exception => ex
      log.update_attributes(:additional_data => ex.message)
    end
    
  end
end