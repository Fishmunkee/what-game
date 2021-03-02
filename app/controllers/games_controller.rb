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

  private

end
