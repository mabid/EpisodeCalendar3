xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
  
    xml.email @email
    xml.auth_key @auth_key
    if @user && @episode
      xml.episode_id @episode_id
      xml.value @value
      xml.result "true"
    else
      xml.result "false"
    end
  
  end
end