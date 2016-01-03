class CreateTalkPosts < ActiveRecord::Migration
  def change
    create_table :talk_posts do |t|
      t.integer :post_id
      t.integer :first_person_id
      t.integer :second_person_id
      t.string :title
      t.string :image_name
      t.string :image_src_url
      t.text :summary
      t.text :body

      t.timestamps null: false
    end
  end
end
