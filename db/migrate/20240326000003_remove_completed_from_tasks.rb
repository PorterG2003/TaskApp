class RemoveCompletedFromTasks < ActiveRecord::Migration[7.1]
  def change
    remove_column :tasks, :completed, :boolean
  end
end