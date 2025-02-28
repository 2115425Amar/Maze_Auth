class AddColumnPublicToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :public, :boolean
  end
end
