class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.datetime :last_login_date
      t.integer :review_counter
      t.datetime :review_last_date
      t.datetime :review_trigger_date

      t.timestamps
    end
  end
end
