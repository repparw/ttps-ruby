class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock, default: 0, null: false
      t.references :category, null: false, foreign_key: true
      t.string :size
      t.string :color
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :products, :name
    add_index :products, :deleted_at
  end
end
