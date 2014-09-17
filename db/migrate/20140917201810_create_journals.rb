class CreateJournals < ActiveRecord::Migration
  def change
    create_table :journals do |t|
      t.text :journal_entry

      t.timestamps
    end
  end
end
