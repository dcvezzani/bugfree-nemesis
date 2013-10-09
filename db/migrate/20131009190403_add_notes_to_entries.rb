class AddNotesToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :notes, :text
  end
end
