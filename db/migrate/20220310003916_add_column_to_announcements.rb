class AddColumnToAnnouncements < ActiveRecord::Migration[6.1]
  def change
    add_column :announcements, :type, :string, null: false
  end
end
