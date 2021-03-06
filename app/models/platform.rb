class Platform < ApplicationRecord
  has_and_belongs_to_many :games
  PLATFORM = ["Xbox SX", "PS5", "Switch", "Steam"]
end
