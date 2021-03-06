class AddIgdbidToPlatforms < ActiveRecord::Migration[6.0]
  def change
    add_column :platforms, :igdb_id, :integer
  end
end
