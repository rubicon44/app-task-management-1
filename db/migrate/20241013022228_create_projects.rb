class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.bigint :user_id, null: false
      t.string :name, null: false
      t.string :description

      t.timestamps
    end
  end
end
