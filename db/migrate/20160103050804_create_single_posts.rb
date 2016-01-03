class CreateSinglePosts < ActiveRecord::Migration
  def change
    create_table :single_posts do |t|
      t.integer :post_id
      t.string :comment
      t.string :ref_title
      t.string :ref_url
      t.string :image_name
      t.string :image_src_url

      t.timestamps null: false
    end
  end
end
