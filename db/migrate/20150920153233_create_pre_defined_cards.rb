class CreatePreDefinedCards < ActiveRecord::Migration
  def change
    create_table :pre_defined_cards do |t|
      t.string :text
      t.string :category

      t.timestamps
    end
  end
end
