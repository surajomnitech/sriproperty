class Package < ApplicationRecord
  # Relationships
  has_many :user_packages
  has_many :users, through: :user_packages
  has_many :user_package_purchases
  has_many :users, through: :user_package_purchases

  # Enums
  enum status: { active: 0, inactive: 1 }

  # Validations
  validates :name, presence: true
  validates :free_listings_count, presence: true, numericality: { greater_than: 0 }
  validates :max_photos_per_listing, presence: true, numericality: { greater_than: 0 }
  validates :free_listings_per_cycle, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :max_paid_listings, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :duration_days, presence: true, numericality: { greater_than: 0 }
  validates :listing_duration_days, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Callbacks
  after_save :ensure_single_default, if: :saved_change_to_is_default?
  before_destroy :prevent_default_deletion
  before_save :handle_default_package

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :default, -> { find_by(is_default: true) }
  scope :paid, -> { where('price > 0') }
  scope :free, -> { where(price: 0) }
  scope :ordered_by_price, -> { order(price: :asc) }
  scope :available_for_purchase, -> { active.where(status: :active) }

  def total_listings_per_cycle
    free_listings_per_cycle + max_paid_listings
  end

  def free?
    price.zero?
  end

  def requires_payment?
    !free? && invoice_required?
  end

  def display_name
    "#{name} (#{duration_description})"
  end

  def duration_description
    if duration_days >= 365
      "#{duration_days / 365} year#{duration_days >= 730 ? 's' : ''}"
    elsif duration_days >= 30
      "#{duration_days / 30} month#{duration_days >= 60 ? 's' : ''}"
    else
      "#{duration_days} days"
    end
  end

  def listing_duration_description
    if listing_duration_days >= 365
      "#{listing_duration_days / 365} year#{listing_duration_days >= 730 ? 's' : ''}"
    elsif listing_duration_days >= 30
      "#{listing_duration_days / 30} month#{listing_duration_days >= 60 ? 's' : ''}"
    else
      "#{listing_duration_days} days"
    end
  end

  def features_summary
    features = []
    features << "#{free_listings_per_cycle} free listings per cycle"
    features << "#{max_paid_listings} maximum paid listings"
    features << "Listings valid for #{listing_duration_description}"
    features << "Package duration: #{duration_description}"
    features << (invoice_required? ? "Invoice required" : "No invoice required")
    features
  end

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

  def handle_default_package
    return unless is_default_changed?

    if is_default?
      Package.where.not(id: id).update_all(is_default: false)
    else
      # Don't allow unsetting if this is the only default package
      if Package.where(is_default: true).count <= 1
        self.is_default = true # Keep it as default
      end
    end
  end
end
