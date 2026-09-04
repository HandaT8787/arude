class CreateResidences < ActiveRecord::Migration[8.0]
  def change
    create_table :residences do |t|
      t.references :user, null: false, foreign_key: true
      t.string :prefecture, null: false
      t.string :city, null: false
      t.date :started_on, null: false
      t.date :ended_on

      t.timestamps
    end
  end
end
