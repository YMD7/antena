class RenamePostTypeColumnToPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :post_type, :type
  end
end
