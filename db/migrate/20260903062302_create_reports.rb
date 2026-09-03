class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.text :reason, null: false

      t.timestamps
    end
    add_index :reports, [:user_id, :comment_id], unique: true
  end
end
