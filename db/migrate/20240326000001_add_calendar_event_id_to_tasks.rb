class AddCalendarEventIdToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :calendar_event_id, :string
    add_index :tasks, [:user_id, :calendar_event_id], unique: true
  end
end