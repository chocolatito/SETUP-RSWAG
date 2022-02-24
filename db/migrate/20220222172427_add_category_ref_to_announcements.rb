class AddCategoryRefToAnnouncements < ActiveRecord::Migration[6.1]
  def change
    add_reference :announcements, :category, null: false, foreign_key: true
  end
end
