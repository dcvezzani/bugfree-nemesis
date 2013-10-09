class AddTypeToEntryStories < ActiveRecord::Migration
  def change
    add_column :entry_stories, :type, :string
  end
end
