class AddDoubleFlatAndDoubleSharpToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :double_flat, :boolean, default: false
    add_column :notes, :double_sharp, :boolean, default: false
  end
end
