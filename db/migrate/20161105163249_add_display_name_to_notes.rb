class AddDisplayNameToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :display_name, :string, default: nil
  end
end
