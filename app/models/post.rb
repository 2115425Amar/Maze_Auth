# app/models/post.rb
class Post < ApplicationRecord
  belongs_to :user
  # has_many :comments, dependent: :destroy
  has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :description, presence: true
end
