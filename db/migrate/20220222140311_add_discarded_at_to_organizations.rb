class AddDiscardedAtToOrganizations < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, :discarded_at, :datetime
    add_index :organizations, :discarded_at
  end
end
