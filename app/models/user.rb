# /home/hp/Desktop/auth2/devise_auth/app/models/user.rb
class User < ApplicationRecord
  rolify
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # validates :first_name, :last_name, :phone_number, presence: true
  validates :first_name,  :phone_number, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, uniqueness: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }

  has_many :posts, dependent: :destroy  # Add this line
  has_many :likes, dependent: :destroy
  has_many :comments, through: :posts

  # Default role assignment
  after_create :assign_default_role
  after_create :send_welcome_email
  after_create :upload_avatar

  # after_update :upload_avatar, if: :avatar_changed?
  def avatar_changed?
    avatar.present? && avatar != avatar_was
  end

  def assign_default_role
    self.add_role(:user) if self.roles.blank? # Assign "user" role by default
  end

  # has_one_attached :avatar
  attr_accessor :avatar
  # after_save :upload_avatar, if: -> { avatar.present? }

  # Methods
  def avatar_url
    if avatar_public_id.present?
      Cloudinary::Utils.cloudinary_url(avatar_public_id, width: 150, height: 150, crop: :fill)
    else
      "img.png" # Default image if no avatar is uploaded
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def active?
    active
  end

  def admin?
    has_role?(:admin)
  end


private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end


  # def upload_avatar
  #   # return unless avatar.present? # Ensure avatar is present

  #   Rails.logger.info "Uploading avatar..."
  #   response = Cloudinary::Uploader.upload(avatar, folder: "avatars")
  #   self.update_column(:avatar_public_id, response["public_id"])

  #   Rails.logger.info "Avatar uploaded successfully: #{response["public_id"]}"  
  # rescue Cloudinary::Error => e
  #   Rails.logger.error "Failed to upload avatar: #{e.message}"
  # end


end
