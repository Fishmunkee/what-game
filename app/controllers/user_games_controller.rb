class UserGamesController < ApplicationController
  def new
    @user_game = UserGame.new
    @game = Game.find(params[:game_id])
  end

  def create
    @game = Game.find(params[:game_id])
    @user_game = Usergame.new(user_game_params)
    @user_game.game = @game
    @user_game.user = current_user
    @user_game.save
  end

  private

  def user_game_params
    params.require(:user_game).permit(:game_id, :user_id)
  end
end
