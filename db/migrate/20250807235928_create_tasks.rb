class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.boolean :completed
      t.integer :priority
      t.date :due_date

      t.timestamps
    end
  end
end
