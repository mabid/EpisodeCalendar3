require 'test_helper'

class HiddenEpisodesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_create_invalid
    HiddenEpisode.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    HiddenEpisode.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to hidden_episodes_url
  end

  def test_destroy
    hidden_episode = HiddenEpisode.first
    delete :destroy, :id => hidden_episode
    assert_redirected_to hidden_episodes_url
    assert !HiddenEpisode.exists?(hidden_episode.id)
  end
end
