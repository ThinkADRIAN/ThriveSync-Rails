class Relationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :relation, :class_name => 'User'

  has_many :pending_relations,
         :through => :relationships,
         :source => :relation
         #:conditions => "confirmed = 0"  # assuming 0 means 'pending'
end
