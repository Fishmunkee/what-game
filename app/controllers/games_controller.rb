class GamesController < ApplicationController

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
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

  def game_params
    params.require(:game).permit(:title, :age_rating, :description, :metacritic)
  end
end
