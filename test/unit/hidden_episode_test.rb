require 'test_helper'

class HiddenEpisodeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert HiddenEpisode.new.valid?
  end
end
