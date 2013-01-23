class TaskFilter < ActiveFilter::Base
  model Task
  
  fields :name, :description, :completed, :deadline_at
  #order 'name ASC', 'description ASC', 'completed ASC', 'deadline_at ASC'
  
end

