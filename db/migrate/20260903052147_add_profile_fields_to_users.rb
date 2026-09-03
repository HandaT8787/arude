class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :bio, :text
    add_column :users, :prefecture, :string
    add_column :users, :city, :string
    add_column :users, :local_years, :integer
    add_column :users, :is_admin, :boolean, default: false, null: false
  end
end
