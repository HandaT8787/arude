class AddLocalYearsAtPostToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :local_years_at_post, :integer
  end
end
