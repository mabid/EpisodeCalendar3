class ShowAttributeVotesController < ApplicationController
  def index
    @show = Show.find_by_permalink(params[:permalink])
    @seasons = Season.where("api_show_id = ?", @show.api_show_id).order("number desc")
    if params[:season]
      @season = Season.where("api_show_id = ? AND number = ?", @show.api_show_id, params[:season]).first
      @season = @seasons.first if @season.blank?
    else
      @season = @seasons.first
    end
    @has_voted = ShowAttributeVote.has_votes_for?(@show.id, current_user)
    @show_attribute_votes = @show.show_attribute_votes #ShowAttributeVote.all
  end

  def show
    @show_attribute_vote = ShowAttributeVote.find(params[:id])
  end

  def new
    @show_attribute_vote = ShowAttributeVote.new
  end

  def create
    @show_attribute_vote = ShowAttributeVote.new(params[:show_attribute_vote])
    if @show_attribute_vote.save
      redirect_to @show_attribute_vote, :notice => "Successfully created show attribute vote."
    else
      render :action => 'new'
    end
  end

  def edit
    @show_attribute_vote = ShowAttributeVote.find(params[:id])
  end

  def update
    @show_attribute_vote = ShowAttributeVote.find(params[:id])
    if @show_attribute_vote.update_attributes(params[:show_attribute_vote])
      redirect_to @show_attribute_vote, :notice  => "Successfully updated show attribute vote."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @show_attribute_vote = ShowAttributeVote.find(params[:id])
    @show_attribute_vote.destroy
    redirect_to show_attribute_votes_url, :notice => "Successfully destroyed show attribute vote."
  end

  def vote
    voteable = ShowAttributeVote.find(params[:id])
    if params[:vote] == "up"
      current_user.vote_exclusively_for(voteable)
      show = voteable.show
      show.update_attributes(voteable.show_attribute.to_sym => voteable.attribute_value)
    else
      current_user.vote_exclusively_against(voteable)
    end
    redirect_to show_attribute_votes_url, :notice => "Successfully voted."
  end

  def unvote
    voteable = ShowAttributeVote.find(params[:id])
    current_user.unvote_for(voteable) # Clears all votes for that user
    redirect_to show_attribute_votes_url, :notice => "Successfully voted."
  end

end
