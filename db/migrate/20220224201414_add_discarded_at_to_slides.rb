class AddDiscardedAtToSlides < ActiveRecord::Migration[6.1]
  def change
    add_column :slides, :discarded_at, :datetime
    add_index :slides, :discarded_at
  end
end
