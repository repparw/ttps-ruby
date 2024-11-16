class AddEntryAndUpdatedToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :entry_at, :datetime
  end
end
