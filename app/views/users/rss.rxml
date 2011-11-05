xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
  
    xml.title       "EpisodeCalendar.com"
    xml.description "Episodes for #{@user.display_name}"
    xml.link        rss_url(@user.email.downcase)
    xml.ttl         180
    
    @rss_items.reverse.each do |item|
      
      item_date = item[0] #Standard time; 00:00
      item_date += @user.day_offset.days

      titleDate = item_date.strftime("%a, %d %b")
      pubDate = item_date.strftime("%a, %d %b %Y %H:%M:%S GMT")

      summaries = []
      banners = item[2]
      episodes = item[1].each do |episode|
        format = 	format_episode_number(episode, @user)
        banner = ""
        unless banners[episode.id].blank?
          banner = image_tag(HOST + image_path(banners[episode.id]))
        end
        if @user.hide_overview_in_rss
          summaries << "#{banner}<br /><strong>#{episode.show.name} - #{episode.name}</strong> (#{format})"
        else
          summaries << "#{banner}<br /><strong>#{episode.show.name} - #{episode.name}</strong> (#{format})<br />#{episode.overview}"
        end
      end
            
      xml.item do
        xml.title titleDate
        xml.description CGI.unescape(summaries.join("<br /><br />"))
        xml.pubDate pubDate
        xml.link "#{HOST}"
        xml.guid "#{HOST}##{episodes.first.id}"
      end
    end
  
  end
end