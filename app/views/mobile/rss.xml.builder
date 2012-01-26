xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
  
    xml.email @email
    unless @user
      xml.result "false"
    else
      xml.result "true"
        
      xml.dates do
        @rss_items.each do |rss_arr|
          
          item_date = rss_arr[0][0] #Standard time; 00:00
          item_date += @user.day_offset.days
          titleDate = item_date.strftime("%Y-%m-%d")
          
          day = rss_arr[0]
          episodes = rss_arr[1]
          
          xml.date "value" => titleDate do
            episodes.each do |episode|
              xml.episode do
                xml.id episode.id
                xml.checked @seen_episode_ids.include?(episode.id)
                xml.show episode.show.name
                xml.number format_episode_number(episode, @user)
                xml.name episode.name
                xml.summary episode.friendly_overview(true) unless @user.hide_overview_in_rss
              end
            end
          end
          
        end #each
      end # dates
    end #unless

  end
end