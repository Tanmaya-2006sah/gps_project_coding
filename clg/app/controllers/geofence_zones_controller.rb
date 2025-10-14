class GeofenceZonesController < ApplicationController
  before_action :set_patient, except: [ :index ]
  before_action :set_geofence_zone, only: [ :show, :edit, :update, :destroy ]

  def index
    @patients = current_user.patients.includes(:geofence_zones)
    @all_zones = GeofenceZone.joins(:patient).where(patient: current_user.patients)
  end

  def show
  end

  def new
    @geofence_zone = @patient.geofence_zones.build
  end

  def create
    @geofence_zone = @patient.geofence_zones.build(geofence_zone_params)

    if @geofence_zone.save
      redirect_to [ @patient, @geofence_zone ], notice: "Geofence zone was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @geofence_zone.update(geofence_zone_params)
      redirect_to [ @patient, @geofence_zone ], notice: "Geofence zone was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @geofence_zone.destroy
    redirect_to @patient, notice: "Geofence zone was successfully deleted."
  end

  private

  def set_patient
    @patient = current_user.patients.find(params[:patient_id]) if params[:patient_id]
  end

  def set_geofence_zone
    if @patient
      @geofence_zone = @patient.geofence_zones.find(params[:id])
    else
      @geofence_zone = GeofenceZone.joins(:patient).where(patient: current_user.patients).find(params[:id])
      @patient = @geofence_zone.patient
    end
  end

  def geofence_zone_params
    params.require(:geofence_zone).permit(:name, :center_latitude, :center_longitude, :radius_meters, :active)
  end
end
