class CreateEffectiveTimeIntervals < ActiveRecord::Migration
  def change
    create_table :effective_time_intervals do |t|
      t.integer :passive_data_point_id
      t.datetime :start_date_time
      t.datetime :end_date_time

      t.timestamps
    end
  end
end
