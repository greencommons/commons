class ApiKey < ApplicationRecord
  before_validation :generate_keys, on: :create

  belongs_to :user

  validates :access_key, presence: true
  validates :secret_key, presence: true
  validates :active, presence: true

  scope :enabled, -> { where(active: true) }

  def disable
    update_column :active, false
  end

  private

  def generate_keys
    self.access_key = SecureRandom.urlsafe_base64
    self.secret_key = SecureRandom.hex
  end
end
