class Game < ApplicationRecord
  has_many :reviews
  has_many :user_games
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :medium
  has_many :games_genres
end
