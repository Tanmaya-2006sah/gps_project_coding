class PatientsController < ApplicationController
  before_action :set_patient, only: [ :show, :edit, :update, :destroy ]

  def index
    @patients = current_user.patients.includes(:vital_signs, :activities, :geofence_zones)
  end

  def show
    @latest_vital_signs = @patient.vital_signs.order(recorded_at: :desc).limit(10)
    @recent_activities = @patient.recent_activities
    @geofence_zones = @patient.geofence_zones.active
    @patient_location = [ @patient.latitude, @patient.longitude ] if @patient.latitude && @patient.longitude
  end

  def new
    @patient = current_user.patients.build
  end

  def create
    @patient = current_user.patients.build(patient_params)

    if @patient.save
      redirect_to @patient, notice: "Patient was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @patient.update(patient_params)
      redirect_to @patient, notice: "Patient was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy
    redirect_to patients_url, notice: "Patient was successfully deleted."
  end

  private

  def set_patient
    @patient = current_user.patients.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:name, :age, :gender, :medical_condition, :latitude, :longitude, :last_seen_at)
  end
end
