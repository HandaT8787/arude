class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :tag_type

      t.timestamps
    end
    add_index :tags, :name, unique: true
  end
end
