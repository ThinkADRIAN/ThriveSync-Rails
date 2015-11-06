class AddResearchStartedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :research_started_at, :datetime
  end
end
