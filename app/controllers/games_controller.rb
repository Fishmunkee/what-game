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

  private

  def game_params
    params.require(:game).permit(:title, :age_rating, :description, :metacritic)
  end
end
