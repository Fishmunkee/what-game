class GamesController < ApplicationController
skip_before_action :authenticate_user!, only: [ :search, :index, :show, :advancedsearch, :random ]
# before_action :user

  def index
    @games = Game.all
  end

  def show
    game_id = params[:id]
    @game = Game.find(game_id)
    @reviews = Review.where("game_id = ?", game_id)
    @recommendations = recommendation(@game) if current_user
    @user_game = UserGame.where("user_id = ? AND game_id = ?", current_user, @game.id)&.first || UserGame.new
  end

  def search
    query = params[:q]

    @games = Game.where("title ILIKE ?", "%#{query}%")
  end

  def advancedsearch
    query = params.dig(:games, :q)
    genre_ids = params.dig(:games, :genre_ids)
    platform_ids = params.dig(:games, :platform_ids)

    if query != nil
      @games = Game.where("title ILIKE ?", "%#{query}%")
    end

    if genre_ids && genre_ids.length > 1
      g_ids = genre_ids[1..-1].map { |genre_id| genre_id.to_i }
      @games = @games.where_exists(:genres, id: g_ids)
    end

    if platform_ids && platform_ids.length > 1
      p_ids = platform_ids[1..-1].map { |platform_id| platform_id.to_i }
      @games = @games.where_exists(:platforms, id: p_ids)
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
