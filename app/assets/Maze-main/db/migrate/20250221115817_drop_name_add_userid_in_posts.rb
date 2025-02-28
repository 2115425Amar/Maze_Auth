class DropNameAddUseridInPosts < ActiveRecord::Migration[8.0]
  def change
    remove_column :posts, :title, :string
    add_column :posts, :user_id, :integer
  end
end
