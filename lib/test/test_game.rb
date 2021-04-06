require 'minitest/autorun'
require_relative '../Game'

class TestGame < MiniTest::Test

  def setup
    @game=Game.new
    @game.points=20
    @game.date="2/20/2021"
    @game.opponent="Michigan"
    @game.fieldGoals=5
    @game.fieldGoalsAttempts=10
    @game.freeThrows=2
    @game.freeThrowsAttempts=9
    @game.offensiveRebounds=6
    @game.defensiveRebounds=1
    @game.steals=1
    @game.assists=7
    @game.blocks=0
    @game.personalFouls=1
    @game.turnovers=2


  end


  def test_gameScore_nil

    assert_equal nil, @game.gameScore
  end


  def test_gameScore

    @game.game_scorepoints
    assert_equal 20.2, @game.gameScore
  end

  

  def test_type
    assert @game.is_a?(Game)
  end

  def test_points
    assert_equal 20, @game.points
  end

  def test_date
    assert_equal "2/20/2021", @game.date
  end

  def test_opponent
    assert_equal "Michigan", @game.opponent
  end

  def test_fieldGoals
    assert_equal 5, @game.fieldGoals
  end

  def test_fieldGoalsAttempts
    assert_equal 10, @game.fieldGoalsAttempts
  end

  def test_freeThrows
    assert_equal 2, @game.freeThrows
  end

  def test_freeThrowsAttempts
    assert_equal 9, @game.freeThrowsAttempts
  end

  def test_offensiveRebounds
    assert_equal 6, @game.offensiveRebounds
  end

  def test_defensiveRebounds
    assert_equal 1, @game.defensiveRebounds
  end

  def test_steals
    assert_equal 1, @game.steals
  end

  def test_assists
    assert_equal 7, @game.assists
  end
  
  def test_blocks
    assert_equal 0, @game.blocks
  end

  def test_personalFouls
    assert_equal 1, @game.personalFouls
  end

  def test_turnovers
    assert_equal 2, @game.turnovers
  end


end