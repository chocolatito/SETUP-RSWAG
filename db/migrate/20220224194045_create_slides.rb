class CreateSlides < ActiveRecord::Migration[6.1]
  def change
    create_table :slides do |t|
      t.text :text
      t.integer :order, null: false
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
    add_index :slides, [:organization_id, :order], unique: true
  end
end
