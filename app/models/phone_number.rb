class PhoneNumber < ApplicationRecord
  belongs_to :user

  # Validations
  validates :number, presence: true, uniqueness: true
  validate :valid_sri_lankan_number
  validates :verification_code, length: { is: 6 }, allow_nil: true
  validates :verification_attempts, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Callbacks
  before_validation :normalize_phone_number
  before_create :set_default_values

  # Constants
  VERIFICATION_CODE_EXPIRY = 10.minutes
  MAX_VERIFICATION_ATTEMPTS = 3
  SRI_LANKAN_MOBILE_PREFIXES = %w[070 071 072 074 075 076 077 078]

  # Methods
  def generate_verification_code
    return false if reached_max_attempts?

    update(
      verification_code: rand(100000..999999).to_s,
      code_expiry: Time.current + VERIFICATION_CODE_EXPIRY,
      verification_attempts: 0
    )
  end

  def verify_code(code)
    return false if code_expired? || reached_max_attempts?
    return false unless verification_code == code

    update(verified: true, verification_code: nil, code_expiry: nil)
    true
  end

  def code_expired?
    code_expiry.present? && code_expiry < Time.current
  end

  def reached_max_attempts?
    verification_attempts >= MAX_VERIFICATION_ATTEMPTS
  end

  def increment_verification_attempts
    increment!(:verification_attempts) unless verified?
  end

  private

  def normalize_phone_number
    return if number.blank?
    
    # Remove any non-digit characters
    cleaned_number = number.to_s.gsub(/\D/, '')
    
    # If it's 9 digits and doesn't start with 0, add a 0
    if cleaned_number.length == 9 && !cleaned_number.start_with?('0')
      cleaned_number = "0#{cleaned_number}"
    end
    
    self.number = cleaned_number
  end

  def valid_sri_lankan_number
    return if number.blank?
    
    cleaned_number = number.to_s.gsub(/\D/, '')
    
    # Check if it's exactly 10 digits starting with 0 or 9 digits not starting with 0
    valid_length = (cleaned_number.length == 10 && cleaned_number.start_with?('0')) ||
                  (cleaned_number.length == 9 && !cleaned_number.start_with?('0'))
    
    # For 10-digit numbers, check if they start with valid Sri Lankan mobile prefixes
    if cleaned_number.length == 10
      valid_prefix = SRI_LANKAN_MOBILE_PREFIXES.any? { |prefix| cleaned_number.start_with?(prefix) }
    else
      # For 9-digit numbers, check if adding a 0 would make it valid
      valid_prefix = SRI_LANKAN_MOBILE_PREFIXES.any? { |prefix| "0#{cleaned_number}".start_with?(prefix) }
    end

    unless valid_length && valid_prefix
      errors.add(:number, "must be a valid Sri Lankan mobile number")
    end
  end

  def set_default_values
    self.verified ||= false
    self.verification_attempts ||= 0
    self.primary ||= false
  end
end
