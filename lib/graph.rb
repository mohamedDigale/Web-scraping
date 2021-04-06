require 'gruff'
require 'set'

require_relative './Game'
require_relative './player'

# Common theme for cohesive graph style

GRAPH_THEME = {
  colors: %w[
      '#000000'
      '#ffee33'
      '#ad2323'
      '#2a4bd7'
      '#ff9233'
      '#1d6914'
      '#8126c0'
      '#814a19'
      '#29d0d0'
      '#575757'
      '#81c57a'
      '#9dafff'
      '#e9debb'
      '#a0a0a0'
      '#ffcdf3'
    ],
  marker_color: '#c0c0c0',
  background_colors: 'white'
}

# Line graph of each player's game score in each game

def graph_team_game_scores_line(team)

  # Create graph object

  graph = Gruff::Line.new('1200x800')
  graph.title = 'OSU Game Scores'

  # Get set of all dates of games played

  game_dates = Set.new
  team.each do |player|
    player.games.each do |game|
      game_dates.add game.date.strip!
    end
  end

  # Sort by chronological order

  game_dates = game_dates.to_a
  game_dates.sort_by! { |date| Date.strptime(date, '%m/%d/%Y') }

  # Create line graph x axis labels

  labels = game_dates.each_with_index.map do |date, index|
    [index, date]
  end
  graph.labels = labels.to_h

  # Create expanded scores array for each player. This corrects incorrect graphing
  # created when a player did not play in a game that is tracked. This way, each
  # player has a game score for every game recorded. If they did not play in a game,
  # their game score is set to their most recent game score. If they didn't play and
  # haven't yet played, their game score is set to zero.

  team.each do |player|
    player_game_dates = player.games.map { |game| game.date}
    player_scores_expanded = []
    labels.each do |label|
      if !(game_index = player_game_dates.index label[1]).nil?
        player_scores_expanded << player.games[game_index].game_score
      elsif !player_game_dates.empty?
        player_scores_expanded << player_scores_expanded.last
      else
        player_scores_expanded << 0
      end
    end
    graph.data player.name.to_sym, player_scores_expanded
  end

  # Set some properties of graph. min_val and max_val are calculated using int division

  graph.theme = GRAPH_THEME
  graph.minimum_value = (graph.minimum_value.round / 5) * 5
  graph.maximum_value = (graph.maximum_value.round / 5 + 1) * 5
  graph.y_axis_increment = 5
  graph.label_stagger_height = 16
  graph.marker_font_size = 12
  graph.title_margin=8
  graph.legend_margin=8
  graph.label_truncation_style = :trailing_dots
  graph.line_width=2
  graph.legend_box_size = 12
  graph.legend_font_size = 12
  graph.show_vertical_markers = true
  graph.hide_dots = true

  # Create graph image file

  graph.write('lib/outputs/GameScLine.png')
end

# Bar graph containing each player's average game score

def graph_average_game_score_bar (team)

  # Create graph object

  graph = Gruff::Bar.new("1200x800")
  graph.title = "Average Game Score"

  # For each player, find their average game score and add it to graph data

  team.each do |player|
    player_avg = player.games.each.map(&:game_score).sum / player.games.length
    graph.data player.name.to_sym, player_avg
  end

  # Set some properties of graph. min_val and max_val are calculated using int division

  graph.theme = GRAPH_THEME
  graph.minimum_value = (graph.minimum_value.round / 2) * 2
  graph.maximum_value = (graph.maximum_value.round / 2 + 1) * 2
  graph.y_axis_increment = 2
  graph.title_margin=8
  graph.legend_margin=8
  graph.label_truncation_style = :trailing_dots
  graph.legend_box_size = 12
  graph.legend_font_size = 12
  graph.show_labels_for_bar_values = true

  # Create graph image file

  graph.write('lib/outputs/GameScBar.png')
end

def graph_player_avg_stats (team)

  # Create graph object

  graph = Gruff::Bar.new("1200x800")
  graph.title = "Average Statistics per Game by Player"

  # Each player as a label

  labels = team.each_with_index.map { |player, index| [index, player.name]}
  graph.labels = labels.to_h

  points_avg = []
  assists_avg = []
  reb_avg = []
  blocks_avg = []
  steals_avg = []

  team.each do |player|
    points_avg << player.games.each.map(&:points).sum.to_f / player.games.length
    assists_avg << player.games.each.map(&:assists).sum.to_f / player.games.length
    reb_avg << player.games.each.map { |game| game.offensive_rebounds + game.defensive_rebounds }.sum.to_f / player.games.length
    blocks_avg << player.games.each.map(&:blocks).sum.to_f / player.games.length
    steals_avg << player.games.each.map(&:steals).sum.to_f / player.games.length
  end

  graph.data "points".to_sym, points_avg
  graph.data "assists".to_sym, assists_avg
  graph.data "rebounds".to_sym, reb_avg
  graph.data "blocks".to_sym, blocks_avg
  graph.data "steals".to_sym, steals_avg

  # Set some properties of graph. min_val and max_val are calculated using int division

  graph.theme = GRAPH_THEME
  graph.minimum_value = (graph.minimum_value.round / 2) * 2
  graph.maximum_value = (graph.maximum_value.round / 2 + 1) * 2
  graph.y_axis_increment = 2
  graph.label_stagger_height = 16
  graph.title_margin=8
  graph.legend_margin=8
  graph.label_truncation_style = :trailing_dots
  graph.legend_box_size = 12
  graph.legend_font_size = 12
  graph.marker_font_size = 12

  # Create graph image file

  graph.write('lib/outputs/StatsBar.png')
end