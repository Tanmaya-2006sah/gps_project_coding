class CreateDeviceLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :device_logs do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :device_type
      t.string :device_id
      t.string :event_type
      t.text :event_data
      t.decimal :latitude
      t.decimal :longitude
      t.integer :battery_level
      t.integer :signal_strength
      t.datetime :recorded_at

      t.timestamps
    end
  end
end
