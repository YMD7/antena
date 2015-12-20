class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :family_name_jp, :string
    add_column :users, :first_name_jp, :string
    add_column :users, :family_name_en, :string
    add_column :users, :first_name_en, :string
    add_column :users, :affiliate, :string
    add_column :users, :role, :string
  end
end
