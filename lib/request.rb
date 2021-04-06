require_relative 'Game.rb'
require 'mechanize'
require 'pp'

# Scrapes a player's personal page (who has a populated "STATS" tab) from the OSU
# Men's Basketball site and returns the included html page filled with the player's
# statistics for each page.
#
# Requires:
#   page - An OSU MBB Player's personal page that has a populated "STATS" tab.
#       Mechanize::page object type.
#
# Returns:
#   new_page - The stats page corresponding to the player of the page input. This
#       page is embedded in the input page in an <iframe> element. The entire
#       embedded page is returned as a Mechanize::page object.

def request_player (page)

  agent = Mechanize.new

  # Attempt to go to the embedded stats page

  new_page = agent.click page.iframes.first

  # If we couldn't find any iframes, look for the link as plaintext within the page
  # This occured for Justice Sueing's page during project completion

  if new_page.title.nil?
    link = page.search(".text:contains(https)").text
    link = link.scan /https:\/\/stats.ohiostatebuckeyes.com\/stats\/[0-9]*/
    agent.get link[0]
    new_page = agent.page
  end

  # Return the Mechanize::page that is just the player's stats tables

  new_page

end

# Scrapes OSU Men's Basketball Roster page from input URL to find player pages that
# contain a "STATS" tab for statistic parsing. The returned array is two dimensional;
# sub arrays contain the player name as the first entity and the player's page object
# as the second entity. Assumes similar page formatting as present during 20-21 season
#
# Requires:
#   url - the URL of the OSU Men's Basketball Roster page. As of 2/18/2021 the current
#       url is https://ohiostatebuckeyes.com/sports/m-baskbl/roster/
#
# Returns:
#   players_with_stats_pages - a two dimensional array containing information
#       for all players found on the roster page that have a populated "STATS"
#       tab on their player page. Each entry of main array corresponds to a player.
#       for each player (each element of main array), the sub array contains the
#       player name as the first entry and the player's page as a Mechanize::page
#       object as the second entry.

def request_team_with_stats url
  agent = Mechanize.new
  agent.get url
    
    
    # Find links to player pages
    #
  all_players = []
  all_links = agent.page.links_with href: %r{/sports/m-baskbl/roster/season/}
    

    # Filter extraneous links with newlines (extra links found on the page)

  all_links.each do |link|
    if link.text() !~ %r{\n}m
      all_players << link
    end
  end

  players_with_stats_pages = []

    # For each player's link, visit and see if a "STATS" tab exists. If so, add them
    # to the array of players with stats pages

  all_players.each do |player_link|
    agent.get player_link.resolved_uri

    # Here is where we search to see if the second tab is available, the "STATS" tab

    unless agent.page.links_with(href: %r{#tab-2}).empty?

      # Add player's name as [0] and their Mechanize::page as [1]

      players_with_stats_pages << [player_link.text(), agent.page]
    end
  end

  players_with_stats_pages

end
