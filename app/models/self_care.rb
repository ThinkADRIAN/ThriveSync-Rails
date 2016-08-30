class SelfCare < ActiveRecord::Base
  belongs_to :user

  validates :counseling, :medication, :meditation, :exercise, :inclusion => [true, false]
  validates_presence_of :timestamp

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |self_care|
        csv << self_care.attributes.values_at(*column_names)
      end
    end
  end
end
