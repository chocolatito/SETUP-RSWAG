class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :name, null: false
      t.string :linkedin_url
      t.string :facebook_url
      t.string :instagram_url
      t.text :description
      t.datetime :discarded_at
      t.index :discarded_at
      t.timestamps
    end
  end
end
