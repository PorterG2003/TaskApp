class AddStatusToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :status, :string, default: "pending"
    add_index :tasks, :status
  end
end