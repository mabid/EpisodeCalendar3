class AdController < ApplicationController
  
  def amazon_product
    req = AmazonProduct["us"]
    req.configure do |c|
      c.key    = "AKIAIYTCNNI4NG2O32SA"
      c.secret = "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"
      c.tag    = "episocalen-20"
    end
    req << { :operation    => 'ItemSearch',
             :search_index => params[:product_type],
             :response_group => %w{ItemAttributes Images},
             :keywords => params[:product_name],
             :sort => "" }
    resp = req.get
    @item = resp.find('Item').shuffle.first
  end
  
end