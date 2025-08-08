class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :google_uid
      t.text :google_token
      t.text :google_refresh_token

      t.timestamps
    end
  end
end
