class UserPackagePurchase < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :package
  has_many :listing_cycles, dependent: :destroy
  has_one_attached :payment_proof
  has_many_attached :payment_documents

  # Enums
  enum payment_status: {
    pending: 0,
    paid: 1,
    cancelled: 2,
    refunded: 3
  }

  # Validations
  validates :units, presence: true, numericality: { greater_than: 0 }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  validate :no_overlapping_active_packages, on: :create
  validate :acceptable_payment_documents

  # Callbacks
  before_validation :set_dates_and_amount, on: :create
  after_create :create_listing_cycles

  # Scopes
  scope :active, -> { where('end_date > ?', Time.current) }
  scope :pending_payment, -> { where(payment_status: :pending) }
  scope :paid, -> { where(payment_status: :paid) }
  scope :recent_first, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }

  def active?
    end_date > Time.current && paid?
  end

  def status
    if active?
      'active'
    elsif cancelled?
      'cancelled'
    elsif paid?
      'expired'
    else
      'pending'
    end
  end

  def total_free_listings
    package.free_listings_per_cycle * units
  end

  def total_paid_listings
    package.max_paid_listings * units
  end

  def free_listings_remaining
    total_free_listings - listing_cycles.sum(:free_listings_used)
  end

  def paid_listings_remaining
    total_paid_listings - listing_cycles.sum(:paid_listings_used)
  end

  def current_cycle
    listing_cycles.find_by('cycle_start_date <= ? AND cycle_end_date > ?', Time.current, Time.current)
  end

  def progress_percentage
    return 0 if end_date <= start_date
    
    total_duration = (end_date - start_date).to_i
    elapsed = (Time.current - start_date).to_i
    percentage = (elapsed.to_f / total_duration * 100).round
    [percentage, 100].min
  end

  def time_remaining
    return 0.seconds unless active?
    end_date - Time.current
  end

  def time_remaining_human
    seconds = time_remaining
    return "Expired" if seconds <= 0

    days = (seconds / 1.day).floor
    months = (days / 30).floor
    years = (months / 12).floor

    if years > 0
      "#{years} year#{years > 1 ? 's' : ''}"
    elsif months > 0
      "#{months} month#{months > 1 ? 's' : ''}"
    else
      "#{days} day#{days > 1 ? 's' : ''}"
    end
  end

  def can_be_cancelled?
    pending? || (paid? && Time.current < start_date)
  end

  def can_be_upgraded?
    active? && paid?
  end

  private

  def set_dates_and_amount
    return unless package

    self.start_date ||= Time.current
    self.end_date = start_date + (package.duration_days * units).days
    self.total_amount = package.price * units
  end

  def create_listing_cycles
    cycle_start = start_date
    units.times do
      cycle_end = cycle_start + package.duration_days.days
      listing_cycles.create!(
        cycle_start_date: cycle_start,
        cycle_end_date: cycle_end,
        free_listings_used: 0,
        paid_listings_used: 0
      )
      cycle_start = cycle_end
    end
  end

  def end_date_after_start_date
    return unless start_date && end_date

    if end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end

  def no_overlapping_active_packages
    if user.user_package_purchases.active.where.not(id: id).exists?
      errors.add(:base, "User already has an active package")
    end
  end

  def acceptable_payment_documents
    return unless payment_documents.attached?

    payment_documents.each do |document|
      unless document.blob.byte_size <= 10.megabytes
        errors.add(:payment_documents, "should be less than 10MB")
      end

      acceptable_types = ["image/png", "image/jpeg", "application/pdf"]
      unless acceptable_types.include?(document.content_type)
        errors.add(:payment_documents, "must be a PNG, JPG, or PDF file")
      end
    end
  end
end