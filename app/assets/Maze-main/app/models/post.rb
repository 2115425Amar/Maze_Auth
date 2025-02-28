class Post < ApplicationRecord
  paginates_per 10
  belongs_to :user, foreign_key: "user_id"
  has_many :comments, dependent: :destroy

  validates :description, presence: true
end
