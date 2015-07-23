class JournalSerializer < ActiveModel::Serializer
  attributes :id, :journal_entry, :timestamp, :created_at, :updated_at, :user_id
end
