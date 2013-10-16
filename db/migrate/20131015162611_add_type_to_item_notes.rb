class AddTypeToItemNotes < ActiveRecord::Migration
  def change
    add_column :item_notes, :type, :string
  end
end
