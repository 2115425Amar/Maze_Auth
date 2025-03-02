class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :phone_number, presence: true

  has_many :posts, dependent: :destroy  # Add this line
  has_many :likes, dependent: :destroy
  has_one_attached :avatar

  # Add this method
  def name
    "#{first_name} #{last_name}"
  end

end
