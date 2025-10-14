class AddTermsAcceptedToCaretakers < ActiveRecord::Migration[8.0]
  def change
    add_column :caretakers, :terms_accepted, :boolean
  end
end
