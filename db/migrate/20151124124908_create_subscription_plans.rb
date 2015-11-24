class CreateSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :subscription_plans do |t|
      t.integer :amount
      t.string :interval
      t.string :stripe_id
      t.string :name
      t.integer :interval_count
      t.integer :trial_period_days

      t.timestamps
    end
  end
end
