class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: true, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :category
      t.string :congestion
      t.integer :price
      t.text :caution
      t.float :latitude
      t.float :longitude
      t.string :prefecture
      t.string :city

      t.timestamps
    end
  end
end
