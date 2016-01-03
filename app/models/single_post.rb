class SinglePost < ActiveRecord::Base
  belongs_to :posts
  accepts_nested_attributes_for :posts
end
