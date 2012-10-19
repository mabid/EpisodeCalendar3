require 'test_helper'

class ShowAttributeVoteTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert ShowAttributeVote.new.valid?
  end
end
