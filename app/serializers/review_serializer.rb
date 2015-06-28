class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :last_login_date, :review_counter, :review_last_date, :review_trigger_date
end
