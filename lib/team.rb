require_relative 'player'
require_relative 'request'

# Populates an array with Player objects with their appropriate data filled in
#
# Requires:
#   roster_array - A two dimensional array as returned by request_team_with_stats
#       in request.rb. This array contains information
#       for all players found on the roster page that have a populated "STATS"
#       tab on their player page. Each entry of main array corresponds to a player.
#       for each player (each element of main array), the sub array contains the
#       player name as the first entry and the player's page as a Mechanize::page
#       object as the second entry.
#
# Returns:
#   team - An array of Player objects with all players who have "STATS" tabs on their
#       personal pages and all of their game statistics filled in by subsequent method
#       calls.

def populate_team(roster_array)

  team = []

  # Here we are populating the team array with Player objects generated from
  # the input roster_array.

  roster_array.each_with_index do |player_with_page, index|

    # Populate player's games (w/ stats), name, and image path

    current_player = populate_player request_player(player_with_page[1])
    current_player.name = player_with_page[0]
    current_player.image = get_player_image(player_with_page[1], index)

    # Add Player object to team

    team << current_player
  end

  team

end
