class CreateTableAddreses < ActiveRecord::Migration[6.0]
  def change
    create_table :addreses do |t|
      t.string :address, null: false
      t.string :district, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false

      t.timestamps
    end

    add_index :addreses, :zip, unique: true
    add_index :addreses, :address
    add_index :addreses, :district
    add_index :addreses, :city
    add_index :addreses, [:address, :district, :city], unique: true
  end
end
