class AddFieldsToCaretakers < ActiveRecord::Migration[8.0]
  def change
    add_column :caretakers, :first_name, :string
    add_column :caretakers, :last_name, :string
    add_column :caretakers, :phone, :string
    add_column :caretakers, :license_number, :string
    add_column :caretakers, :specialization, :string
    add_column :caretakers, :years_experience, :integer
    add_column :caretakers, :active, :boolean
  end
end
