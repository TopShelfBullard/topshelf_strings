class CreateInstruments < ActiveRecord::Migration
  def change
    create_table :instruments do |t|
      t.string :value, null: false
      t.string :display_name, null: false
      t.integer :number_of_frets, null: false
      t.integer :number_of_strings, null: false
      t.integer :open_string_values, array: true, null: false
      t.timestamps null: false
    end
  end
end
