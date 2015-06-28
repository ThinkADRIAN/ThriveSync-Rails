class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :review_counter, :review_last_date, :review_trigger_date
end
