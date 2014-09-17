class CreateMoods < ActiveRecord::Migration
  def change
    create_table :moods do |t|
      t.integer :mood_rating
      t.integer :anxiety_rating
      t.integer :irritability_rating
      t.datetime :timestamp

      t.timestamps
    end
  end
end
