class Post < ActiveRecord::Base
  has_many :single_posts
  accepts_nested_attributes_for :single_posts
  has_many :talk_posts
  accepts_nested_attributes_for :talk_posts
end
