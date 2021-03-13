class GamesController < ApplicationController
skip_before_action :authenticate_user!, only: [ :search, :index ]
before_action :user

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
    genre_ids = params[:genre_ids]
    platform_ids = params[:platform_ids]

    @games = Game.where("title ILIKE ?", "%#{query}%")

    if genre_ids != nil
      @games = @games.where_exists(:genres, id: genre_ids.split(','))
    end
    if platform_ids != nil
      @games = @games.where_exists(:platforms, id: platform_ids.split(','))
    end
  end


  def random
    redirect_to :action => "show", :id => Game.pluck(:id).sample
  end

  private

  def recommendation(game)
    @games = Game.where_exists(:genres, id: game.genres.ids)
    @games = @games.where_exists(:platforms, id: game.platforms.ids)
    @games = @games.where_not_exists(:user_games, user_id: current_user.id, completed: true)
    @games = @games.where_not_exists(:user_games, user_id: current_user.id, recommend: false)
  end

  def user
    @user = current_user
  end


end
