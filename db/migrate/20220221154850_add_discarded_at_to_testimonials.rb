class AddDiscardedAtToTestimonials < ActiveRecord::Migration[6.1]
  def change
    add_column :testimonials, :discarded_at, :datetime
    add_index :testimonials, :discarded_at
  end
end
