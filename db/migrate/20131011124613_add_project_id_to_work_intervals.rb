class AddProjectIdToWorkIntervals < ActiveRecord::Migration
  def change
    add_column :work_intervals, :project_id, :integer
  end
end
