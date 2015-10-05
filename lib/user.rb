require 'bcrypt'

class User < ActiveRecord::Base
  has_many :subscriptions
  has_many :services, through: :subscriptions

  attr_accessor :location, :password
  attr_encrypted :phone, :key => ENV["ATTR_ENCRYPTED_KEY"]

  validates_confirmation_of :password
  validates :phone, presence: true
  validate :is_phone_unique?
  # validates :phone, uniqueness: true

  before_save :encrypt_password

  def is_phone_unique?
    matching_users = User.all.select{ |u| u.phone == self.phone }
    unless matching_users.count == 0
      errors.add(:phone, "number is already registered!  Please login.")
    end
  end

  def encrypt_password
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end
  #
  # def self.authenticate(phone, password)
  #   user = User.find_by(phone)
  #   if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
  #     user
  #   else
  #     nil
  #   end
  # end
end
