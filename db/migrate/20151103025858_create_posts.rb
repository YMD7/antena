class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.text :comment
      t.string :seed_title
      t.string :seed_url
      t.integer :image_id
      t.string :image_src

      t.timestamps null: false
    end
  end
end
