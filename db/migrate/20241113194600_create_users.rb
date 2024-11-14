class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :phone, null: false
      t.integer :role, default: 0, null: false, limit: 1
      t.datetime :deactivated_at
      t.datetime :joined_at, null: false

      t.timestamps
    end

    add_index :users, :username, unique: true
  end
end