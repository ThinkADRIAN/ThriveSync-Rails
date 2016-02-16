class AddEffectiveDateTimeToPassiveDataPoints < ActiveRecord::Migration
  def change
    add_column :passive_data_points, :effective_date_time, :datetime
  end
end
