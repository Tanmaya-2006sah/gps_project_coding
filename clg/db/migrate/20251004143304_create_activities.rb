class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :activity_type
      t.text :description
      t.datetime :recorded_at
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
