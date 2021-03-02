class Review < ApplicationRecord
  belongs_to :game
  belongs_to :user

  # validates :description, presence: true
  validates :rating, inclusion: { in: 1..100 }, numericality: { only_integer: true }
end
