class FaqsController < ApplicationController
  
  def index
    @faqs = Faq.all
  end
  
  def sort
    params[:faq].each_with_index do |id, index|
      Faq.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end
  
end 