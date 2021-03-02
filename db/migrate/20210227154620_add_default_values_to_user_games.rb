class AddDefaultValuesToUserGames < ActiveRecord::Migration[6.0]
  def change
    change_column :user_games, :completed, :boolean, :default => false
    change_column :user_games, :owned, :boolean, :default => false
    change_column :user_games, :wishlist, :boolean, :default => false
    change_column :user_games, :recommend, :boolean, :default => false
  end
end
