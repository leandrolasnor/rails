class CreateTableAddressAssignment < ActiveRecord::Migration[6.0]
  def change
    create_table :address_assignments do |t|
      t.integer :user_id, null: false
      t.integer :address_id, null: false

      t.timestamps
    end

    add_index :address_assignments, :user_id
    add_index :address_assignments, :address_id
    add_index :address_assignments, [:address_id, :user_id], unique: true
  end
end
