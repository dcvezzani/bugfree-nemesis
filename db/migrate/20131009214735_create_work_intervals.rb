class CreateWorkIntervals < ActiveRecord::Migration
  def change
    create_table :work_intervals do |t|
      t.integer :entry_id
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end
  end
end
