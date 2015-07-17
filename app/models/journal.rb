class Journal < ActiveRecord::Base
	belongs_to :user

  validates_presence_of :journal_entry, :timestamp
end
