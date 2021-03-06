class GamesController < ApplicationController

  def index
    @games = Game.all
    query = params[:q]
    @games_result = Game.where("name ILIKE ?", "%#{query}%")
  end

  def show
    game_id = params[:id]
    @game = Game.find(game_id)
    @reviews = Reviews.where("game_id = ?", game_id)
  end

  def search
    query = params[:q]
    @games = Game.where("title ILIKE ?", "%#{query}%")
  end

  def random
    @game = Game.find(rand(1..Game.count))
  end

  def show
    @game = Game.find(params[:id])
    @recommendations = recommendation(@game)
  end

  private

  def recommendation(game)
    @games = Game.where_exists(:genres, id: game.genres.ids)
    @games = Game.where_exists(:platforms, id: game.platforms.ids)
    @games = @games.where_not_exists(:user_games, user_id: current_user.id, completed: true)
    @games = @games.where_not_exists(:user_games, user_id: current_user.id, recommend: true)
  end

  # private

end
