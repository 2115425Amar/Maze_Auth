# app/models/post.rb
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :content, presence: true
end

# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :likes, as: :likeable, dependent: :destroy

  validates :content, presence: true
end

# app/models/like.rb
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
