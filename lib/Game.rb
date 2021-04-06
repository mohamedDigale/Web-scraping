require 'mechanize'

# The Game class. Objects contain details about a OSU MBB game and a single player's stats
# for that game. game_score contains the calculated game score according to the formula
# discussed in the output html page and README.
# Attributes:
#   date - the date of the game
#   opponent - the team that OSU MBB played against on the date of the game
#   game_score - the calculated evaluation of player performance
#   points - player's points in game
#   field_goals - player's field goals made in game
#   field_goal_attempts - player's field goals attempted in game
#   free_throws - player's free throws made in game
#   free_throw_attempts - player's free throws attempted in game
#   offensive_rebounds - player's offensive rebounds completed in game
#   defensive_rebounds - player's defensive rebounds completed in game
#   steals - player's steals completed in game
#   assists - player's assists completed in game
#   blocks - player's blocks completed in game
#   personal_fouls - player's personal fouls committed in game
#   turnovers - player's turnovers committed in game
class Game

  attr_accessor :date, :opponent, :game_score, :points, :field_goals, :field_goal_attempts, :free_throws, :free_throw_attempts, :offensive_rebounds, :defensive_rebounds, :steals, :assists, :blocks, :personal_fouls, :turnovers

  # Calculates the game score for a given Game based on the player's statistics

  def game_scorepoints

    # Player score formula
    score = @points + (0.4 * @field_goals) - (0.7 * @field_goal_attempts) - (0.4 * (@free_throw_attempts - @free_throws))
    score += (0.7 * @offensive_rebounds) + (0.3 * @defensive_rebounds) + @steals + (0.7 * @assists) + (0.7 * @blocks) - (0.4 * @personal_fouls) - @turnovers

    @game_score = score.round(1)
end

end

# Populates a game object that contains a player's statistics and information
# about a certain game of the current OSU MBB season. The date and opponent
# corresponding to the game are stored, as well as all of the appropriate
# player's statistics needed to calculate each game score as defined in
# the game_scorepoints function in Game.rb.
#
# Requires:
#   game - The game object to mutate. This is the object of class Game that
#       holds the data we are populating.
#   table - The table of data scraped from the player's "STATS" page as provided
#       by request_player in request.rb
#
# Returns:
#   None
#       NOTE: The input game object is mutated to store the appropriate data.
def populate_game (table)

  game = Game.new

  # Getting values for game class from the game stats table

  game.date = table.css('td.overlay-column')[0].text
  game.opponent = table.css('td')[1].text
  game.points = table.css('td')[2].text.to_i

  game.offensive_rebounds = table.css('td')[10].text.to_i
  game.defensive_rebounds = table.css('td')[11].text.to_i
  game.personal_fouls = table.css('td')[13].text.to_i
  game.assists = table.css('td')[14].text.to_i
  game.turnovers = table.css('td')[15].text.to_i
  game.blocks = table.css('td')[16].text.to_i
  game.steals = table.css('td')[17].text.to_i

  # field_goals and field_goal_attempts are in the same element like this "2-6"
  # must split and analyze separately

  field_goals_per_attempt = table.css('td')[4].text
  temp = field_goals_per_attempt.split("-")

  game.field_goals = temp[0].to_i
  game.field_goal_attempts = temp[1].to_i

  # free_throws and free_throw_attempts are in the same element like this "2-6"
  # must split and analyze separately

  free_throws_per_attempt = table.css('td')[8].text
  temp2 = free_throws_per_attempt.split("-")

  game.free_throws = temp2[0].to_i
  game.free_throw_attempts = temp2[1].to_i

  game.game_scorepoints

  game

end
