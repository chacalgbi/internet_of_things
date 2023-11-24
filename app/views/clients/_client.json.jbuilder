json.extract! client, :id, :name, :email, :cel, :address_mqtt, :obs, :created_at, :updated_at
json.url client_url(client, format: :json)
