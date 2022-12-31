class CreateTableLoans < ActiveRecord::Migration[6.1]
  def change
    create_table :loans do |t|
      t.integer :rate, null: false
      t.bigint :pv, null: false
      t.integer :nper, null: false
      t.references :user, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
