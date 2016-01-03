class RemoveColumnFromPost < ActiveRecord::Migration
  def change
    remove_column :posts, :user_id, :integer
    remove_column :posts, :comment, :text
    remove_column :posts, :seed_title, :string
    remove_column :posts, :seed_url, :string
    remove_column :posts, :image_id, :integer
    remove_column :posts, :image_src, :string
  end
end
