class CreateSelfCares < ActiveRecord::Migration
  def change
    create_table :self_cares do |t|
      t.boolean :counseling
      t.boolean :medication
      t.boolean :meditation
      t.boolean :exercise

      t.timestamps
    end
  end
end
