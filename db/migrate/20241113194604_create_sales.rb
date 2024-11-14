class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.references :user, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.decimal :total, precision: 10, scale: 2, null: false
      t.datetime :cancelled_at

      t.timestamps
    end
  end
end
