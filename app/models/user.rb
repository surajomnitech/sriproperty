class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  # Enums with string values
  enum role: { individual: 'individual', corporate: 'corporate', admin: 'admin' }
  enum status: { pending: 'pending', active: 'active', suspended: 'suspended' }

  # Associations
  has_many :phone_numbers, dependent: :destroy
  has_one :corporate_profile, dependent: :destroy
  accepts_nested_attributes_for :phone_numbers, allow_destroy: true
  accepts_nested_attributes_for :corporate_profile, allow_destroy: true

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true
  validates :status, presence: true

  # Pagination
  paginates_per 10

  # Callbacks
  after_initialize :set_default_role, if: :new_record?

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    role == 'admin' || admin == true
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name || auth.info.name.split(' ').first
      user.last_name = auth.info.last_name || auth.info.name.split(' ').last
      user.role = 'individual' # Default role for OAuth users
      user.status = 'active'   # Auto-activate OAuth users
      user.skip_confirmation! # Skip email confirmation for OAuth users
    end

    # Update user info if it has changed
    if user.persisted?
      user.update(
        first_name: auth.info.first_name || auth.info.name.split(' ').first,
        last_name: auth.info.last_name || auth.info.name.split(' ').last
      )
    end
    
    user
  end

  private

  def set_default_role
    self.role ||= 'individual'
    self.status ||= 'pending'
  end
end
