class AddIntervalsToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :half_step_id,          :integer, default: nil
    add_column :notes, :whole_step_id,         :integer, default: nil
    add_column :notes, :minor_third_id,        :integer, default: nil
    add_column :notes, :major_third_id,        :integer, default: nil
    add_column :notes, :perfect_fourth_id,     :integer, default: nil
    add_column :notes, :augmented_fourth_id,   :integer, default: nil
    add_column :notes, :diminished_fifth_id,   :integer, default: nil
    add_column :notes, :perfect_fifth_id,      :integer, default: nil
    add_column :notes, :augmented_fifth_id,    :integer, default: nil
    add_column :notes, :minor_sixth_id,        :integer, default: nil
    add_column :notes, :major_sixth_id,        :integer, default: nil
    add_column :notes, :diminished_seventh_id, :integer, default: nil
    add_column :notes, :minor_seventh_id,      :integer, default: nil
    add_column :notes, :major_seventh_id,      :integer, default: nil
  end
end
