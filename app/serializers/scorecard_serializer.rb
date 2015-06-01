class ScorecardSerializer < ActiveModel::Serializer
  attributes :id, :checkin_count, :perfect_checkin_count, :last_checkin_date, :streak_count, :streak_record, :moods_score, :sleeps_score, :self_cares_score, :journals_score
end
