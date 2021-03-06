class Game < ApplicationRecord
  has_many :reviews
  has_many :user_games
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :medium
  PLATFORMS = ["Xbox SX", "PS5", "Switch", "Steam"]
end
