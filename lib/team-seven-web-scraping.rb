require 'launchy'

require_relative 'request'
require_relative 'team'
require_relative 'graph'
require_relative 'Game'
require_relative 'create-html'

# Get roster array of players with stats pages

roster_with_stats = request_team_with_stats('https://ohiostatebuckeyes.com/sports/m-baskbl/roster/')

# Build the team array

team = populate_team roster_with_stats

# Generate graphs

graph_team_game_scores_line team
graph_average_game_score_bar team
graph_player_avg_stats team

# Generate html output page

create_html(team)

# Open the output html page

Launchy.open "lib/outputs/index.html"
