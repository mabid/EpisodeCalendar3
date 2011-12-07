module FaqHelper
  
  def render_textile(content)
    RedCloth.new(content.gsub(/(!)([^_]+)(!)/){ |i| $1 + image_path($2) + $3 }).to_html
  end
  
end