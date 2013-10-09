class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.date :due_on
      t.string :title
      t.text :description
      t.float :hours_est
      t.float :hours_worked
      t.float :hours_todo
      t.date :stopped_since

      t.timestamps
    end
  end
end
