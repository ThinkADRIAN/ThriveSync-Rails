class CreateSleeps < ActiveRecord::Migration
  def change
    create_table :sleeps do |t|
      t.datetime :start_time
      t.datetime :finish_time
      t.integer :quality

      t.timestamps
    end
  end
end
