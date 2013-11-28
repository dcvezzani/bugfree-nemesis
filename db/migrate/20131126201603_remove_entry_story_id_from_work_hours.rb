class RemoveEntryStoryIdFromWorkHours < ActiveRecord::Migration
  def up
    remove_column :work_hours, :entry_story_id
  end

  def down
    add_column :work_hours, :entry_story_id, :integer
  end
end
