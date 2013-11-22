json.array!(@transactions) do |transaction|
  json.extract! transaction, :description, :amount, :date, :category_id
  json.url transaction_url(transaction, format: :json)
end
