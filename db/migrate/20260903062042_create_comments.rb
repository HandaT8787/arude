class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.text :body, null: false
      t.boolean :is_checked, null: false, default: false
      t.datetime :checked_at

      t.timestamps
    end
  end
end
