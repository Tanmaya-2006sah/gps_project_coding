class AddConfirmableToCaretakers < ActiveRecord::Migration[8.0]
  def change
    add_column :caretakers, :confirmation_token, :string
    add_column :caretakers, :confirmed_at, :datetime
    add_column :caretakers, :confirmation_sent_at, :datetime
  end
end
