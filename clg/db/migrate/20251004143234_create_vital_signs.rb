class CreateVitalSigns < ActiveRecord::Migration[8.0]
  def change
    create_table :vital_signs do |t|
      t.references :patient, null: false, foreign_key: true
      t.integer :heart_rate
      t.integer :blood_pressure_systolic
      t.integer :blood_pressure_diastolic
      t.decimal :temperature
      t.datetime :recorded_at

      t.timestamps
    end
  end
end
