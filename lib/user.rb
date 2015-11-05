class User < ActiveRecord::Base
  has_many :subscriptions
  has_many :services, through: :subscriptions

  attr_accessor :password
  attr_encrypted :phone, :key => ENV["ATTR_ENCRYPTED_KEY"]

  validates_confirmation_of :password, on: :create
  before_save :encrypt_password
  validate :validation_suite
  validates_presence_of :password, on: :create
  after_create :send_out_new_code

  def validation_suite
    is_phone_present?
    is_phone_US_mobile?
    is_phone_unique?
  end

  def is_phone_US_mobile?
    parsed_number = Phonelib.parse(phone)
    valid_types = [:mobile, :sms_services, :fixed_or_mobile]
    unless parsed_number.possible? && parsed_number.valid_for_country?('US') && valid_types.include?(parsed_number.type)
      errors.add(:phone, "number is not a valid US mobile number!")
    end
  end

  def is_phone_unique?
    matching_user = User.find_by(encrypted_phone: User.encrypt_phone(phone))
    if matching_user && matching_user.id != id
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

  def send_out_new_code
    ensure_eligble_for_new_code
    set_new_confirmation_code
    send_confirmation_message
  end

  def confirm_phone(code_input)
    ensure_eligible_to_be_confirmed
    confirm_verification_code(code_input)
  end

private

  def confirm_verification_code(code_input)
    if code_input.gsub(/\W/, "").upcase == self.confirmation_code
      self.confirmed = true
      self.save!
    else
      raise OmniBotError, "The code you entered is not correct"
    end
  end

  def ensure_eligible_to_be_confirmed
    if Time.now > (self.confirmation_time + (CODE_VALID_TIME * 60))
      raise OmniBotError, "This code has expired. Please click 'Resend Code' below"
    end
  end

  def ensure_eligble_for_new_code
    self.total_confirmations += 1
    if self.total_confirmations > MAX_CONFIRMATIONS
      raise OmniBotError, "This number has had too many confirmation attempts."
    end
  end

  def set_new_confirmation_code
    code_digit_set = ENV['CONFIRMATION_CODE_SET'].split('')
    self.confirmation_code = code_digit_set.shuffle[0,6].join
    self.confirmation_time = Time.now
    self.save!
  end

  def send_confirmation_message
    text = "Welcome to OmniBot! Please enter this verification code: #{confirmation_code}"
    message = Message.new(body: text, recipient: phone)
    message.send
  end
end
