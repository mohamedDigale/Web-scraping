require 'minitest/autorun'
require_relative '../player'

class TestPlayer < MiniTest::Test

  def setup
    @player=Player.new
    @player.link="WWW.osu.edu"


  end

  def test_type
    assert @player.is_a?(Player)
  end


  def test_link

    assert_equal "WWW.osu.edu", @player.link
  end

end