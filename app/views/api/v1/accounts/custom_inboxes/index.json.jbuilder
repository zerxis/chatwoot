json.array! @custom_inboxes do |custom_inbox|
  json.partial! 'api/v1/models/custom_inbox', formats: [:json], resource: custom_inbox
end
