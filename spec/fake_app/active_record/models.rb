# models
class Task < ActiveRecord::Base
  attr_accessible :completed, :deadline_at, :description, :list_id, :name, :user_id
end

#migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :user_id
      t.integer :list_id
      t.string :name
      t.text :description
      t.boolean :completed
      t.datetime :deadline_at
    end
  end
end
ActiveRecord::Migration.verbose = false
CreateAllTables.up

