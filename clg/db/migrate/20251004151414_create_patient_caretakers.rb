class CreatePatientCaretakers < ActiveRecord::Migration[8.0]
  def change
    create_table :patient_caretakers do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :caretaker, null: false, foreign_key: true
      t.datetime :assigned_at
      t.boolean :primary_caretaker
      t.text :notes

      t.timestamps
    end
  end
end
