class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :firebase_id
      t.text :bio, limit: 160
      t.string :email, null: false
      t.string :nickname, limit: 50, null: false
      t.string :username, limit: 15, null: false

      t.timestamps
    end
  end
end