class UserGamesController < ApplicationController
  def new
  end

  def create
  end

  def recommendations
    UserGame.where_exists(:completed, false, :owned, :wishlist, :recommend, false)
  end
end
