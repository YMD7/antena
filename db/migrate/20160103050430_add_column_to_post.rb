class AddColumnToPost < ActiveRecord::Migration
  def change
    add_column :posts, :author_id, :integer
    add_column :posts, :post_type, :string
  end
end
