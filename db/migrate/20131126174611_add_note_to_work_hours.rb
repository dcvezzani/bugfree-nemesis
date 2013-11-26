class AddNoteToWorkHours < ActiveRecord::Migration
  def change
    add_column :work_hours, :note, :string
  end
end
