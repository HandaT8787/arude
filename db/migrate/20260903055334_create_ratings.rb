class CreateRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :ratings do |t|
      t.references :visit, null: false, foreign_key: true
      t.string :category, null: false
      t.integer :score, null:false

      t.timestamps
    end
  end
end
