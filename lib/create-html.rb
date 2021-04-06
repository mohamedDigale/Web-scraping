require 'erb'

# Background colors to match player series colors on graphs

@background_colors = %w[
      #000000
      #ffee33
      #ad2323
      #2a4bd7
      #ff9233
      #1d6914
      #8126c0
      #814a19
      #29d0d0
      #575757
      #81c57a
      #9dafff
      #e9debb
      #a0a0a0
      #ffcdf3
]

# Using the ERB template to create index.html
# @player_image_space sits in a table row and is populated with player 'cards' - boxes with
# player photos and their name that link to their embedded stats page

def create_html (team)

  # populate @player_image_space with a 'card' for each player

  @player_image_space = ""
  team.each_with_index do |player, index|
    @player_image_space.concat "      <td class='player-photo' style='background-color:#{@background_colors[index]};'>\n"
    @player_image_space.concat "        <a href='#{player.link}'>\n"
    @player_image_space.concat "          <img src='#{player.image}' class='player-photo'/>\n"
    @player_image_space.concat "        </a>\n"
    @player_image_space.concat "        <p class='photo-text'>#{player.name}</p>"
    @player_image_space.concat "      </td>\n"
  end

  # get template

  template = File.read('lib/index.html.template.erb')
  result = ERB.new(template).result(binding)

  # write html file output

  File.open('lib/outputs/index.html', 'w+') do |file|
    file.write result
  end
end