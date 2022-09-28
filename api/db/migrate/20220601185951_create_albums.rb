class CreateAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.integer :artist_id, null: false
      t.string  :name, null: false
      t.integer :year, null: false

      t.timestamps
    end

    add_index :albums, :name
  end
end
