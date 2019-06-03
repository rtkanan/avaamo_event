json.extract! event, :id, :title, :description, :starttime, :endtime, :allday, :is_complete, :created_at, :updated_at
json.url event_url(event, format: :json)
