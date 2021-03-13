class UserGamesController < ApplicationController
  before_action :user

  def setstatus
    usergame = UserGame.where("user_id = ? AND game_id = ?", current_user, params["user_game"]["game_id"])
    if usergame.first != nil
      usergame.update(usergames_params)
     else
      usergame = UserGame.new(usergames_params)
      usergame.user = current_user
      usergame.save
    end
      game = Game.find(params["user_game"]["game_id"])
      redirect_to game
  end

  def recommendations
    usergames = UserGame.where("user_id = ?", current_user)

    genres = Hash.new(0)
    usergames.each do |usergame|
      usergame.game.genres.each do |genre|
        genres[genre.id] += 1
      end
    end

    popular_genres = Hash[genres.sort_by{|k,v| -v}]

    genre1games = Genre.find(popular_genres.keys[0]).games.order('metacritic desc')
    genre1games = genre1games.where_not_exists(:user_games, user_id: current_user.id, completed: true)
    genre1games = genre1games.where_not_exists(:user_games, user_id: current_user.id, recommend: false)

    @games = genre1games.take(20)

    if popular_genres.size > 1
      genre2games = Genre.find(popular_genres.keys[1]).games.order('metacritic desc')
      genre2games = genre2games.where_not_exists(:user_games, user_id: current_user.id, completed: true)
      genre2games = genre2games.where_not_exists(:user_games, user_id: current_user.id, recommend: false)

      @games += genre2games.take(20)

      if popular_genres.size > 2
        genre3games = Genre.find(popular_genres.keys[2]).games.order('metacritic desc')
        genre3games = genre3games.where_not_exists(:user_games, user_id: current_user.id, completed: true)
        genre3games = genre3games.where_not_exists(:user_games, user_id: current_user.id, recommend: false)

        @games += genre3games.take(20)
      end
    end

    @games = @games.uniq.shuffle.take(20)

  end

  private

  def usergames_params
    params.require(:user_game).permit(:game_id, :owned, :completed, :wishlist, :recommend)
  end


  def user
    @user = current_user
  end
end
