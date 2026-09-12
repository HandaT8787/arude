class AddIsGuestToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :is_guest, :boolean, default: false, null: false
  end
end
