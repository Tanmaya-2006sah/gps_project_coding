class PatientCaretaker < ApplicationRecord
  belongs_to :patient
  belongs_to :caretaker

  # Validations
  validates :assigned_at, presence: true
  validates :patient_id, uniqueness: { scope: :caretaker_id }
  validate :only_one_primary_caretaker_per_patient

  # Scopes
  scope :primary, -> { where(primary_caretaker: true) }
  scope :active_assignments, -> { joins(:caretaker).where(caretakers: { active: true }) }

  # Methods
  def assignment_duration
    return nil unless assigned_at
    Time.current - assigned_at
  end

  def assignment_duration_in_words
    return "Not assigned" unless assigned_at
    ActionController::Base.helpers.distance_of_time_in_words(assigned_at, Time.current)
  end

  private

  def only_one_primary_caretaker_per_patient
    if primary_caretaker? && patient_id.present?
      existing_primary = PatientCaretaker.where(patient_id: patient_id, primary_caretaker: true)
                                        .where.not(id: id)
      if existing_primary.exists?
        errors.add(:primary_caretaker, "Patient can only have one primary caretaker")
      end
    end
  end
end
