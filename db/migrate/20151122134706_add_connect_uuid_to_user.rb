class AddConnectUuidToUser < ActiveRecord::Migration
  def change
    add_column :users, :connect_uuid, :string
  end
end
