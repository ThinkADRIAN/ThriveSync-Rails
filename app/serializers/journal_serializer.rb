class JournalSerializer < ActiveModel::Serializer
  attributes :id, :journal_entry, :timestamp, :user_id
end
