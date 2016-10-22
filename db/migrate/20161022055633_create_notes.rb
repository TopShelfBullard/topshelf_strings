class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string  :name,   null: false
      t.string  :letter, null: false
      t.boolean :flat,   null: false, default: false
      t.boolean :sharp,  null: false, default: false
      t.integer :value

      t.timestamps null: false
    end
  end
end
