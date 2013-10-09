class CreateEntryStories < ActiveRecord::Migration
  def change
    create_table :entry_stories do |t|
      t.integer :entry_id
      t.integer :story_id

      t.timestamps
    end
  end
end
