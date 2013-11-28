class CreateStoryWorkHours < ActiveRecord::Migration
  def change
    create_table :story_work_hours do |t|
      t.integer :story_id
      t.integer :work_hour_id

      t.timestamps
    end
  end
end
