class AddDiscardedAtToRoles < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :discarded_at, :datetime
    add_index :roles, :discarded_at
  end
end
