class UsersController < ApplicationController
  def show
    @user_game = UserGame.where(user_id: current_user.id)
    @user_game_owned = UserGame.where(user_id: current_user.id).where(owned: true)
    @user_game_wishlist = UserGame.where(user_id: current_user.id).where(wishlist: true)
    @user_game_completed = UserGame.where(user_id: current_user.id).where(completed: true)
  end 
end
