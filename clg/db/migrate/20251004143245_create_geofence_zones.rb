class CreateGeofenceZones < ActiveRecord::Migration[8.0]
  def change
    create_table :geofence_zones do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :name
      t.decimal :center_latitude
      t.decimal :center_longitude
      t.integer :radius_meters
      t.boolean :active

      t.timestamps
    end
  end
end
