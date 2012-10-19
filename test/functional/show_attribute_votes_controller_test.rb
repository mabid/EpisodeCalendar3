require 'test_helper'

class ShowAttributeVotesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => ShowAttributeVote.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    ShowAttributeVote.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    ShowAttributeVote.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to show_attribute_vote_url(assigns(:show_attribute_vote))
  end

  def test_edit
    get :edit, :id => ShowAttributeVote.first
    assert_template 'edit'
  end

  def test_update_invalid
    ShowAttributeVote.any_instance.stubs(:valid?).returns(false)
    put :update, :id => ShowAttributeVote.first
    assert_template 'edit'
  end

  def test_update_valid
    ShowAttributeVote.any_instance.stubs(:valid?).returns(true)
    put :update, :id => ShowAttributeVote.first
    assert_redirected_to show_attribute_vote_url(assigns(:show_attribute_vote))
  end

  def test_destroy
    show_attribute_vote = ShowAttributeVote.first
    delete :destroy, :id => show_attribute_vote
    assert_redirected_to show_attribute_votes_url
    assert !ShowAttributeVote.exists?(show_attribute_vote.id)
  end
end
