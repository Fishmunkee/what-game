class CreateMedia < ActiveRecord::Migration[6.0]
  def change
    create_table :media do |t|
      t.string :url
      t.string :media_type

      t.timestamps
    end
  end
end
