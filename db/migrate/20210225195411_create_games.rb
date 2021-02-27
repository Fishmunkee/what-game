class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :title
      t.string :age_rating
      t.string :description
      t.string :metacritic

      t.timestamps
    end
  end
end
