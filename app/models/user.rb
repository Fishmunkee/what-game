class User < ApplicationRecord
  has_one_attached :avatar
  has_many :user_games
  has_many :games, through: :user_games
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
