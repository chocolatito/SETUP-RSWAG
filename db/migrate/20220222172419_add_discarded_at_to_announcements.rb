class AddDiscardedAtToAnnouncements < ActiveRecord::Migration[6.1]
  def change
    add_column :announcements, :discarded_at, :datetime
    add_index :announcements, :discarded_at
  end
end
