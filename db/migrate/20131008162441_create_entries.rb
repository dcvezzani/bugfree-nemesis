class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.date :recorded_for
      t.string :title
      t.text :yesterdays_log
      t.text :todays_log
      t.text :show_stopper_log

      t.timestamps
    end
  end
end
