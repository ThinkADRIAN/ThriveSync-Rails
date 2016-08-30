class Sleep < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :start_time, :finish_time
  validates :time, numericality: {only_integer: true}
  validates :quality, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4}

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |sleep|
        csv << sleep.attributes.values_at(*column_names)
      end
    end
  end
end
