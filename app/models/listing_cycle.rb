class ListingCycle < ApplicationRecord
  # Relationships
  belongs_to :user_package_purchase
  has_one :package, through: :user_package_purchase
  has_one :user, through: :user_package_purchase

  # Validations
  validates :cycle_start_date, presence: true
  validates :cycle_end_date, presence: true
  validates :free_listings_used, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :paid_listings_used, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :cycle_end_date_after_start_date
  validate :listings_within_limits

  # Scopes
  scope :active, -> { where('cycle_end_date > ?', Time.current) }
  scope :for_user, ->(user) { joins(:user_package_purchase).where(user_package_purchases: { user_id: user.id }) }
  scope :current, -> { where('cycle_start_date <= ? AND cycle_end_date > ?', Time.current, Time.current) }
  scope :past, -> { where('cycle_end_date <= ?', Time.current) }
  scope :future, -> { where('cycle_start_date > ?', Time.current) }
  scope :ordered_by_date, -> { order(cycle_start_date: :asc) }

  def active?
    cycle_end_date > Time.current
  end

  def current?
    active? && cycle_start_date <= Time.current
  end

  def free_listings_remaining
    package.free_listings_per_cycle - free_listings_used
  end

  def paid_listings_remaining
    package.max_paid_listings - paid_listings_used
  end

  def total_listings_used
    free_listings_used + paid_listings_used
  end

  def total_listings_remaining
    free_listings_remaining + paid_listings_remaining
  end

  def progress_percentage
    return 0 if cycle_end_date <= cycle_start_date
    
    total_duration = (cycle_end_date - cycle_start_date).to_i
    elapsed = (Time.current - cycle_start_date).to_i
    percentage = (elapsed.to_f / total_duration * 100).round
    [percentage, 100].min
  end

  def can_add_free_listing?
    active? && free_listings_remaining.positive?
  end

  def can_add_paid_listing?
    active? && paid_listings_remaining.positive?
  end

  def status
    if cycle_end_date <= Time.current
      'expired'
    elsif cycle_start_date > Time.current
      'upcoming'
    else
      'active'
    end
  end

  private

  def cycle_end_date_after_start_date
    return unless cycle_start_date && cycle_end_date

    if cycle_end_date <= cycle_start_date
      errors.add(:cycle_end_date, "must be after start date")
    end
  end

  def listings_within_limits
    return unless package && (free_listings_used_changed? || paid_listings_used_changed?)

    if free_listings_used > package.free_listings_per_cycle
      errors.add(:free_listings_used, "cannot exceed package limit of #{package.free_listings_per_cycle}")
    end

    if paid_listings_used > package.max_paid_listings
      errors.add(:paid_listings_used, "cannot exceed package limit of #{package.max_paid_listings}")
    end
  end
end