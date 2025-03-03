class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :phone_number, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, uniqueness: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }


  has_many :posts, dependent: :destroy  # Add this line
  has_many :likes, dependent: :destroy
  has_one_attached :avatar

  after_create :assign_default_role
  # his runs after a user is created.
  # It assigns a default role (user) if the user has no roles.

  # Add this method
  def name
    "#{first_name} #{last_name}"
  end

  def avatar_url
    avatar.attached? ? Rails.application.routes.url_helpers.url_for(avatar) : 'earth.png'
  end

  def assign_default_role
    self.add_role(:user) if self.roles.blank? # Assign "user" role by default
  end

  def active?
    active
  end

end
