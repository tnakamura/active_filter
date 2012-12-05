class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.integer :list_id
      t.string :name
      t.text :description
      t.boolean :completed
      t.datetime :deadline_at

      t.timestamps
    end
  end
end
