class GamesController < ApplicationController

  def index
    @games = Game.all
  end

  def show
    game_id = params[:id]
    @game = Game.find(game_id)
    @reviews = Reviews.where("game_id = ?", game_id)
  end

  def search
    query = params[:q]
    @games = Game.where("name ILIKE ?", "%#{query}%")
  end

  def random
    @game = Game.find(rand(1..Game.count))
  end

  def show
    @game = Game.find(params[:id])
    # @recommendations = Game.where(genre: @game.genre)
    recommendation(@game)
  end

  def recommendation(game)
    @game = Game.where_exists(:genres, name: game.genres.pluck(:name))
    @games = Game.where_not_exists(:user_games, user_id: current_user.id, completed: true)
    raise
  end

  private

end
