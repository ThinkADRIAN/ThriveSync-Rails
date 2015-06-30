class RemoveLastLoginDateFromReviews < ActiveRecord::Migration
  def change
    remove_column :reviews, :last_login_date, :datetime
  end
end
