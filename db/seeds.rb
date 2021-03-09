require 'open-uri'
require 'net/http'
require 'json'

@limit = 500
@twitch_client_id = ENV["TWITCH_CLIENT_ID"]
@twitch_client_secret = ENV["TWITCH_SECRET"]

def get_auth
  response = Net::HTTP.post_form(URI.parse("https://id.twitch.tv/oauth2/token"), {client_id: @twitch_client_id, client_secret: @twitch_client_secret, grant_type: "client_credentials"})
  response = JSON.parse(response.body)
  return response["access_token"]
end

def get_genres(token)
  http = Net::HTTP.new('api.igdb.com',443)
  http.use_ssl = true
  request = Net::HTTP::Post.new(URI('https://api.igdb.com/v4/genres'), {'Client-ID' => @twitch_client_id, 'Authorization' => "Bearer #{token}"})
  request.body = 'fields name; limit 500;'
  response = http.request(request).body
  json = JSON.parse(response)

  json.each do |genre|
    Genre.create(igdb_id: genre["id"], name: genre["name"])
  end
end

def get_games(token, offset)
  http = Net::HTTP.new('api.igdb.com',443)
  http.use_ssl = true
  request = Net::HTTP::Post.new(URI('https://api.igdb.com/v4/games'), {'Client-ID' => @twitch_client_id, 'Authorization' => "Bearer #{token}"})
  request.body = "fields name,total_rating,genres,platforms,summary; limit #{@limit}; offset #{offset}; where platforms = (6, 48, 49, 130, 167, 169) & first_release_date > 1299092080 & genres != null & total_rating_count > 0;"
  response = http.request(request).body
  json = JSON.parse(response)

  json.each do |game|
    g = Game.create(title: game["name"], metacritic: game["total_rating"], description: game["summary"])

    game["genres"].each do |genre|
      g.genres << Genre.find_by(igdb_id: genre)
    end

    game["platforms"].each do |platform|
      p = Platform.find_by(igdb_id: platform)
      g.platforms << p if p != nil
    end
  end

  return json.size
end

puts "Starting ingest of IGDB. Put on a pot of coffee, this is going to take a while!"
puts "Starting time: #{Time.now}"

puts "Clearing existing data"
UserGame.destroy_all
GamesGenre.destroy_all
GamesPlatform.destroy_all
Review.destroy_all
User.destroy_all
Game.destroy_all
Genre.destroy_all
Platform.destroy_all
Medium.destroy_all

puts "Seeding the users..."
olli = User.create!(email: "olli@whatgame.com", password: "password")
nette = User.create!(email: "nette@whatgame.com", password: "password")
andy = User.create!(email: "andy@whatgame.com", password: "password")
tristan = User.create!(email: "tristan@whatgame.com", password: "password")

# Insert platforms manually with known data
puts "Inserting platforms"

Platform.create(igdb_id: 6, name: "PC")
Platform.create(igdb_id: 48, name: "Playstation 4")
Platform.create(igdb_id: 49, name: "Xbox One")
Platform.create(igdb_id: 130, name: "Nintendo Switch")
Platform.create(igdb_id: 167, name: "Playstation 5")
Platform.create(igdb_id: 169, name: "Xbox Series")

puts "Inserting platforms complete"

#Get OAuth token from IGBD
puts "Getting OAuth token"
token = get_auth
puts "Retreived OAuth token"

# Insert all genres
puts "Inserting genres"
get_genres(token)
puts "Inserting genres completed"

# Insert all games
puts "Inserting games"

offset = 0
games_count = 1

while games_count > 0 do
  puts "Getting games from #{offset} to #{offset + @limit}"
  games_count = get_games(token, offset)
  offset += @limit
end

puts "Inserting games completed"

puts "Seeding process completed!"
puts "Completed at: #{Time.now}"
