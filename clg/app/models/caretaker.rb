class Caretaker < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Associations
  has_many :patient_caretakers, dependent: :destroy
  has_many :patients, through: :patient_caretakers
  has_many :primary_patients, -> { where(patient_caretakers: { primary_caretaker: true }) },
           through: :patient_caretakers, source: :patient

  # Validations
  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :phone, format: { with: /\A[\d\-\s\+\(\)]+\z/, message: "Invalid phone number format" }, allow_blank: true
  validates :license_number, presence: true, uniqueness: true
  validates :specialization, presence: true
  validates :years_experience, presence: true, numericality: { greater_than: 0, less_than: 50 }
  validates :terms_accepted, acceptance: true, on: :create

  # Scopes
  scope :active, -> { where(active: true) }
  scope :by_specialization, ->(spec) { where(specialization: spec) if spec.present? }

  # Methods
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def display_name
    "Dr. #{full_name}"
  end

  def primary_patients_count
    patient_caretakers.where(primary_caretaker: true).count
  end

  def total_patients_count
    patients.count
  end

  def recent_device_logs
    DeviceLog.joins(:patient).where(patient: patients).recent.limit(50)
  end

  def critical_alerts_count
    # Count critical vital signs and alerts for assigned patients
    patients.joins(:vital_signs)
           .where(vital_signs: { recorded_at: 24.hours.ago..Time.current })
           .count { |p| p.latest_vital_signs&.status == "critical" }
  end

  def patients_needing_attention
    patients.select do |patient|
      latest_vitals = patient.latest_vital_signs
      latest_vitals && (latest_vitals.status == "critical" || latest_vitals.status == "warning")
    end
  end
end
