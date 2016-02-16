class CreatePassiveDataPoints < ActiveRecord::Migration
  def change
    create_table :passive_data_points do |t|
      t.integer :user_id
      t.boolean :was_user_entered
      t.string :timezone
      t.string :source_uuid
      t.string :external_uuid
      t.datetime :creation_date_time
      t.string :schema_namespace
      t.string :schema_name
      t.string :schema_version

      t.timestamps
    end
  end
end
