class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :rails_user, index: true
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
