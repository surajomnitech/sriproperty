class UserPackage < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :package

  # Enums
  enum status: { active: 0, expired: 1, cancelled: 2 }

  # Validations
  validates :listings_consumed, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
  validate :one_active_package_per_user

  # Scopes
  scope :active, -> { where(status: :active) }

  # Methods
  def can_post_listing?
    return false unless active?
    listings_consumed < package.free_listings_count
  end

  def available_listings
    package.free_listings_count - listings_consumed
  end

  private

  def one_active_package_per_user
    return unless active?
    
    existing_active = UserPackage.active
                                .where(user_id: user_id)
                                .where.not(id: id)
                                .exists?
    
    if existing_active
      errors.add(:base, 'User already has an active package')
    end
  end
end
