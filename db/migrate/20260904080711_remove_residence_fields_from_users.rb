class RemoveResidenceFieldsFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :prefecture, :string
    remove_column :users, :city, :string
    remove_column :users, :local_years, :integer
  end
end
