class AddLatitudeAndLongitudeToResidences < ActiveRecord::Migration[8.0]
  def change
    add_column :residences, :latitude, :float
    add_column :residences, :longitude, :float
  end
end
