json.array!(@pre_defined_cards) do |pre_defined_card|
  json.extract! pre_defined_card, :id, :text, :category
  json.url pre_defined_card_url(pre_defined_card, format: :json)
end
