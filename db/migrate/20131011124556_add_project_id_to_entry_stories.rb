class AddProjectIdToEntryStories < ActiveRecord::Migration
  def change
    add_column :entry_stories, :project_id, :integer
  end
end
