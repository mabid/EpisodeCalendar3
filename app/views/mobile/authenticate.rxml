xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
  
    xml.email @email
    xml.password @password
    if @valid_user
      xml.auth_key @auth_key
      xml.result "true"
    else
      xml.result "false"
    end
  
  end
end