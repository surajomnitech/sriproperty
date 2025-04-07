class CorporateProfile < ApplicationRecord
  belongs_to :user

  # Validations
  validates :business_name, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 50, maximum: 1000 }
  validates :business_hours, presence: true
  validates :address, presence: true
  validates :established_year, numericality: { 
    only_integer: true,
    greater_than_or_equal_to: 1900,
    less_than_or_equal_to: -> { Time.current.year }
  }, allow_nil: true

  # Active Storage for logo
  has_one_attached :logo

  # Validate logo
  validate :acceptable_logo

  private

  def acceptable_logo
    return unless logo.attached?

    unless logo.blob.byte_size <= 5.megabyte
      errors.add(:logo, "is too big (should be less than 5MB)")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(logo.content_type)
      errors.add(:logo, "must be a JPEG or PNG")
    end
  end
end
