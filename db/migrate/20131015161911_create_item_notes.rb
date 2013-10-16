class CreateItemNotes < ActiveRecord::Migration
  def change
    create_table :item_notes do |t|
      t.integer :item_id
      t.integer :note_id

      t.timestamps
    end
  end
end
