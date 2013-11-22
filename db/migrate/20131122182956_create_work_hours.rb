class CreateWorkHours < ActiveRecord::Migration
  def change
    create_table :work_hours do |t|
      t.float :hours
      t.references :entry_story

      t.timestamps
    end
    add_index :work_hours, :entry_story_id
  end
end
