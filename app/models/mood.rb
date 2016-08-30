class Mood < ActiveRecord::Base
  belongs_to :user

  validates :mood_rating, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 7}
  validates :anxiety_rating, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4}
  validates :irritability_rating, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4}
  validates_presence_of :timestamp

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |mood|
        csv << mood.attributes.values_at(*column_names)
      end
    end
  end
end