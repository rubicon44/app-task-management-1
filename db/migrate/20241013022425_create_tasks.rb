class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.bigint :user_id, null: false
      t.string :title, null: false
      t.text :content
      t.integer :status, null: false
      t.string :start_date, null: false
      t.string :end_date, null: false
      t.bigint :project_id, null: false

      t.timestamps
    end
  end
end
