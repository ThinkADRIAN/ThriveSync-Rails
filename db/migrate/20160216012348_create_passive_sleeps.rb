class CreatePassiveSleeps < ActiveRecord::Migration
  def change
    create_table :passive_sleeps do |t|
      t.integer :passive_data_id
      t.string :category_type
      t.string :category_value
      t.float :value
      t.string :unit

      t.timestamps
    end
  end
end
