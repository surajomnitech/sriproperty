class Package < ApplicationRecord
  # Relationships
  has_many :user_packages
  has_many :users, through: :user_packages

  # Enums
  enum status: { active: 0, inactive: 1 }

  # Validations
  validates :name, presence: true
  validates :free_listings_count, presence: true, numericality: { greater_than: 0 }
  validates :max_photos_per_listing, presence: true, numericality: { greater_than: 0 }

  # Callbacks
  after_save :ensure_single_default, if: :saved_change_to_is_default?
  before_destroy :prevent_default_deletion

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :default, -> { find_by(is_default: true) }

  private

  def ensure_single_default
    if is_default?
      self.class.where.not(id: id).update_all(is_default: false)
    elsif self.class.where(is_default: true).count.zero?
      # If no default package exists, make this one default
      update_column(:is_default, true)
    end
  end

  def prevent_default_deletion
    if is_default?
      errors.add(:base, 'Cannot delete the default package')
      throw :abort
    end
  end
end
