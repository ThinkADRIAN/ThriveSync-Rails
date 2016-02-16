class CreatePassiveWorkouts < ActiveRecord::Migration
  def change
    create_table :passive_workouts do |t|
      t.integer :passive_data_point_id
      t.string :workout_type
      t.float :kcal_burned_value
      t.string :kcal_burned_unit
      t.float :distance_value
      t.string :distance_unit

      t.timestamps
    end
  end
end
