class TaskFilter < ActiveFilter::Base
  model Task
  
  fields :name, :description, :completed, :deadline_at
  
end

