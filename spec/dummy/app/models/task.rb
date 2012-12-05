class Task < ActiveRecord::Base
  attr_accessible :completed, :deadline_at, :description, :list_id, :name, :user_id
end
