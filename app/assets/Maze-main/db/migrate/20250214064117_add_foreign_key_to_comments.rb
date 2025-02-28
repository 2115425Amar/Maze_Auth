class AddForeignKeyToComments < ActiveRecord::Migration[8.0]
  def change
    # add_reference :comments, :post, foreign_key: true   #this will add a foreign key to the comments table which references the post table
    add_column :comments, :post_id, :integer
  end
end
