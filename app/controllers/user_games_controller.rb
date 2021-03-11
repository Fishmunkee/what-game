class UserGamesController < ApplicationController

  def setstatus
    usergame = UserGame.where("user_id = ? AND game_id = ?", current_user, usergames_params)
    if usergame != nil {
      usergame.update(usergames_params)
    } else {
      usergame = UserGame.new(usergames_params)
      usergame.user = current_user
      usergame.save
    }
  end

  def recommendations
    usergames = UserGame.where("user_id = ?", current_user)

    genres = Hash.new(0)
    usergames.each do |usergame|
      usergame.genres.each do |genre|
        genres[genre.id] += 1
      end
    end

    popular_genres = Hash[genres.sort_by{|k,v| -v}]

    @games = Genre.find(popular_genres.keys[0]).games.order('metacritic desc').take(5)
    if popular_genres.size > 1
      @games += Genre.find(popular_genres.keys[1]).games.order('metacritic desc').take(5)

      if popular_genres.size > 2
        @games += Genre.find(popular_genres.keys[2]).games.order('metacritic desc').take(5)
      end
    end

    @games = @games.where_not_exists(:user_games, user_id: current_user.id, completed: true)
    @games = @games.where_not_exists(:user_games, user_id: current_user.id, recommend: false)

  end

  private

  def usergames_params
    params.require(:usergames).permit(:game_id, :owned, :completed, :wishlist, :recommend)
  end

end
