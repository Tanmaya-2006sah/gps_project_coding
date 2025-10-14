class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.text :medical_condition
      t.references :user, null: false, foreign_key: true
      t.decimal :latitude
      t.decimal :longitude
      t.datetime :last_seen_at

      t.timestamps
    end
  end
end
