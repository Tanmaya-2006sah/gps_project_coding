class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Associations
  has_many :patients, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # Validations
  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :phone, format: { with: /\A[\d\-\s\+\(\)]+\z/, message: "Invalid phone number format" }, allow_blank: true
  validates :relationship_to_patient, length: { maximum: 100 }

  # Methods
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def unread_notifications_count
    notifications.where(read: false).count
  end

  def priority_notifications
    notifications.where(read: false, priority: [ "high", "critical" ]).order(created_at: :desc)
  end
end
