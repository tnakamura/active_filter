class <%= class_name %>Filter < ActiveFilter::Base
  model <%= class_name %>
  <% if 0 < attributes.size %>
  fields <%= attributes.map{ |attr| ":" + attr.name }.join(", ") %>
  #order <%= attributes.map{ |attr| "'#{attr.name} ASC'" }.join(", ") %>
  <% end %>
end

