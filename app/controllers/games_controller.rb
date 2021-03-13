class GamesController < ApplicationController
skip_before_action :authenticate_user!, only: [ :search, :index ]

  def index
    @games = Game.all
  end

  def show
    game_id = params[:id]
    @game = Game.find(game_id)
    @reviews = Review.where("game_id = ?", game_id)
    @recommendations = recommendation(@game)
    @user_game = UserGame.new
  end

  def search
    query = params[:q]
    @games = Game.where("title ILIKE ?", "%#{query}%")
  end

  def random
    @game = Game.find(rand(1..Game.count))
  end

  private

  def recommendation(game)
    @games = Game.where_exists(:genres, id: game.genres.ids)
    @games = Game.where_exists(:platforms, id: game.platforms.ids)
    @games = @games.where_not_exists(:user_games, user_id: current_user.id, completed: true)
    @games = @games.where_not_exists(:user_games, user_id: current_user.id, recommend: false)
  end

  # private

end
