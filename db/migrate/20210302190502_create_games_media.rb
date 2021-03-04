class CreateGamesMedia < ActiveRecord::Migration[6.0]
  def change
    create_table :games_media do |t|
      t.references :game, null: false, foreign_key: true
      t.references :medium, null: false, foreign_key: true

      t.timestamps
    end
  end
end
