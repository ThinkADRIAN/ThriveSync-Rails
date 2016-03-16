class CreatePassiveActivities < ActiveRecord::Migration
  def change
    create_table :passive_activities do |t|
      t.integer :passive_data_point_id
      t.string :type
      t.float :value
      t.string :unit
      t.float :kcal_burned_value
      t.string :kcal_burned_unit
      t.float :step_count

      t.timestamps
    end
  end
end
