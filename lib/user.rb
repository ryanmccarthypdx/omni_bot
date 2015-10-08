require 'bcrypt'

class User < ActiveRecord::Base
  has_many :subscriptions
  has_many :services, through: :subscriptions

  attr_accessor :location, :password
  attr_encrypted :phone, :key => ENV["ATTR_ENCRYPTED_KEY"]

  validates_confirmation_of :password
  before_save :encrypt_password
  validate :validation_suite

  def validation_suite
    is_phone_present?
    is_phone_US_mobile?
    is_phone_unique?
  end

  def is_phone_US_mobile?
    parsed_number = Phonelib.parse(self.phone)
    valid_types = [:mobile, :sms_services, :fixed_or_mobile]
    unless parsed_number.possible? && parsed_number.valid_for_country?('US') && valid_types.include?(parsed_number.type)
      errors.add(:phone, "number is not a valid US mobile number!")
    end
  end

  def is_phone_unique?
    matching_users = User.all.select{ |u| u.phone == self.phone && u.id != self.id }
    unless matching_users.count == 0
      errors.add(:phone, "number is already registered!  Please login.")
    end
  end

  def is_phone_present?
    unless !!phone
      errors.add(:phone, "can't be blank")
    end
  end

  def encrypt_password
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end

  # def self.authenticate(phone, password)
  #   user = User.find_by(phone)
  #   if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
  #     user
  #   else
  #     nil
  #   end
  # end
end
