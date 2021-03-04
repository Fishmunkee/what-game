# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Game.destroy_all
Genre.destroy_all
Platform.destroy_all
Medium.destroy_all
Review.destroy_all
UserGame.destroy_all
GamesGenre.destroy_all
GamesPlatform.destroy_all

puts "Seeding the users..."
olli = User.create!(
  email: "olli@whatgame.com",
  password: "password"
  )

nette = User.create!(
  email: "nette@whatgame.com",
  password: "password"
  )

andy = User.create!(
  email: "andy@whatgame.com",
  password: "password"
  )

tristan = User.create!(
  email: "tristan@whatgame.com",
  password: "password"
  )

puts "Seeding the game database..."
10.times do game = Game.create!(
  title: Faker::Game.title,
  age_rating: "3+",
  description: "This game is very good",
  metacritic: "Metacritic score"
  )
end

puts "Seeding the Genres..."
10.times do genre = Genre.create!(
  name: Faker::Game.genre
  )
end

puts "Seeding the Game Genres"
50.times do games_genre = GamesGenre.create!(
  game_id: Game.all.sample.id,
  genre_id: Genre.all.sample.id
  )
end

puts "Seeding the platforms..."
7.times do platform = Platform.create!(
  name: Faker::Game.platform
  )
end

puts "seeding the Game Platforms..."
50.times do games_platform = GamesPlatform.create!(
  game_id: Game.all.sample.id,
  platform_id: Platform.all.sample.id
  )
end
puts "Seeding the media..."
5.times do media = Medium.create!(
  url: "https://google.com",
  media_type: "YouTube Video"
  )
end

puts "Seeding reviews..."
2.times do review = Review.create!(
  rating: rand(1..5),
  description: "good game",
  game_id: rand(1..10),
  user_id: rand(1..4)
  )
end

puts "Seeding user games..."
3.times do user_games = UserGame.create!(
  completed: false,
  owned: true,
  wishlist: false,
  recommend: true,
  game_id: rand(1..10),
  user_id: rand(1..4)
  )
end


puts "Finished seeding!"
