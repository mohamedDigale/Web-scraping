require 'mechanize'
require 'open-uri'

require_relative 'Game'

# The Player class. Each represents a player on the OSU MBB team. Contains an array
# of Game objects that have the player's statistics for each game they've played.
# Attributes:
#   name - the player's name
#   games - an array containing Game objects with the player's statistics
#   image - the path to the player's image
#   link - the URI to the player's embedded stats page
class Player

    attr_accessor :name
    attr_accessor :games
    attr_accessor :image
    attr_accessor :link

    def initialize

        @games=Array.new

    end
end

# Populates and returns a Player object for an OSU MBB player that has a personal
# page with a populated "STATS" tab. This calls populate_game in order to find the
# player's statistics for each game listed on their page.
#
# Requires:
#   page - A Mechanize::page object that corresponds to the player's personal page.
#     this is the page scraped in order to populate the player's statistics for each
#     game.
#
# Returns:
#   player - A completed Player object as defined in player.rb containing all of
#     a player's statistics for each game as listed on their personal page.

def populate_player (page)

    player = Player.new

    # find the table with game-by-game stats
    table = page.css('section.stats--table-container')[2]

    if !table.nil?
        table = table.css('tbody tr')
    end

    # for each row in table create Game and populate it with the stats of that game
    table.each do |xml|

        player.games.push(populate_game(xml)) if xml.children.length > 5

    end

    # Store the link to the player's stats page

    player.link = page.uri

    player

end

# Parses the URI for the player's image from their personal page and downloads it
# to the photos directory. Returns the local path to the downloaded photo. If no
# photo is found on the page, the default photo path is returned.
#
# Requires:
#   page - A Mechanize::page object that corresponds to the player's personal page.
#     this is the page scraped in order to find the player's photo.
#   index - the index of the current player in the team array.
#
# Returns:
#   image_path - local path to the photo to use for the player.

def get_player_image (page, index)
    photo_downloaded = false

    # Attempt to find div that contains image

    image_divs = page.css('div.ohio-staff--photo')

    # If found, continue

    if !image_divs.nil? && !image_divs[0].children.empty?

        # Get image text from returned object

        image_url = image_divs.to_s

        # We only want the url, scan with regex

        image_url = image_url.scan /https[a-zA-Z0-9\-\/\.:]*.jpg/

        # Only continue at this point if we were able to parse a url

        unless image_url.empty?

            # Download image file

            open(image_url.first) do |image|
                File.open("lib/outputs/photos/PlayerPhoto#{index}.jpg", "wb") do |file|
                    file.write(image.read)
                end
            end
            photo_downloaded = true
        end
    end

    # If we couldn't find, return path to default image. Otherwise return local path

    unless photo_downloaded
        return "photos/default.jpg"
    end

    "photos/PlayerPhoto#{index}.jpg"

end