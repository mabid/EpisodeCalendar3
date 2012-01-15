xml.instruct!
 
xml.urlset "xmlns" => "http://www.google.com/schemas/sitemap/0.84" do
  xml.url do
    xml.loc         "http://www.episodecalendar.com/"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "always"
  end

  xml.url do
    xml.loc         "http://www.episodecalendar.com/public"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "always"
    xml.priority    0.9
  end
    
  @tags.each do |show|
    xml.url do
      xml.loc         url_for(:only_path => false, :controller => "/shows", :action => "show", :permalink => show.permalink)
      xml.lastmod     w3c_date(show.updated_at)
      xml.changefreq  "daily"
      xml.priority    0.9
    end
  end
  
  xml.url do
    xml.loc         "http://www.episodecalendar.com/trends"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.8
  end
  
  xml.url do
    xml.loc         "http://www.episodecalendar.com/shows"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "daily"
    xml.priority    0.7
  end

  xml.url do
    xml.loc         "http://www.episodecalendar.com/features"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end
  
  xml.url do
    xml.loc         "http://www.episodecalendar.com/login"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "monthly"
    xml.priority    0.6
  end
  
  xml.url do
    xml.loc         "http://www.episodecalendar.com/signup"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "monthly"
    xml.priority    0.6
  end  
 
end