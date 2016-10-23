class Data::Notes
  def self.create_all
    [
      [["cbb", 11], ["cb", 12], ["c", 1 ], ["c#", 2 ], ["c##", 3  ]],
      [["dbb", 1 ], ["db", 2 ], ["d", 3 ], ["d#", 4 ], ["d##", 5  ]],
      [["ebb", 3 ], ["eb", 4 ], ["e", 5 ], ["e#", 6 ], ["e##", 7  ]],
      [["fbb", 4 ], ["fb", 5 ], ["f", 6 ], ["f#", 7 ], ["f##", 8  ]],
      [["gbb", 6 ], ["gb", 7 ], ["g", 8 ], ["g#", 9 ], ["g##", 10 ]],
      [["abb", 8 ], ["ab", 9 ], ["a", 10], ["a#", 11], ["a##", 12 ]],
      [["bbb", 10], ["bb", 11], ["b", 12], ["b#", 1 ], ["b##", 2  ]]
    ].each do |note_letter_group|
      double_flat_note, flat_note, note, sharp_note, double_sharp_note = note_letter_group
      double_flat_name, double_flat_value = double_flat_note
      flat_name, flat_value = flat_note
      name, value = note
      sharp_name, sharp_value = sharp_note
      double_sharp_name, double_sharp_value = double_sharp_note

      Note.create!( name: double_flat_name,  letter: name, value: double_flat_value,  double_flat: true  )
      Note.create!( name: flat_name,         letter: name, value: flat_value,         flat: true         )
      Note.create!( name: name,              letter: name, value: value                                  )
      Note.create!( name: sharp_name,        letter: name, value: sharp_value,        sharp: true        )
      Note.create!( name: double_sharp_name, letter: name, value: double_sharp_value, double_sharp: true )
    end
  end
end