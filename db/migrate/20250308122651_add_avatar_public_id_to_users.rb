class AddAvatarPublicIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :avatar_public_id, :string
  end
end
