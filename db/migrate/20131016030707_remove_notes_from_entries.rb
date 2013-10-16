class RemoveNotesFromEntries < ActiveRecord::Migration
  def up
    remove_column :entries, :notes
  end

  def down
    add_column :entries, :notes, :text
  end
end
