class AddDurationColumnsToPassiveWorkout < ActiveRecord::Migration
  def change
    add_column :passive_workouts, :duration_value, :float
    add_column :passive_workouts, :duration_unit, :string
  end
end
