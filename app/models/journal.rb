class Journal < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :journal_entry, :timestamp

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |journal|
        csv << journal.attributes.values_at(*column_names)
      end
    end
  end
end
