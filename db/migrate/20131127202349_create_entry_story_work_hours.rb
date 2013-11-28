class CreateEntryStoryWorkHours < ActiveRecord::Migration
  def change
    create_table :entry_story_work_hours do |t|
      t.integer :entry_story_id
      t.integer :work_hour_id

      t.timestamps
    end
  end
end
