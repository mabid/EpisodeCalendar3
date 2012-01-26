class FaqsController < ApplicationController
  
  def index
    @important = Faq.important
    @faqs = Faq.where(:important => false)
    @ticket = Ticket.new
  end
  
  def sort
    params[:faq].each_with_index do |id, index|
      Faq.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end
  
end 