[
  [["cb", 12], ["c", 1 ], ["c#", 2 ]],
  [["db", 2 ], ["d", 3 ], ["d#", 4 ]],
  [["eb", 4 ], ["e", 5 ], ["e#", 6 ]],
  [["fb", 5 ], ["f", 6 ], ["f#", 7 ]],
  [["gb", 7 ], ["g", 8 ], ["g#", 9 ]],
  [["ab", 9 ], ["a", 10], ["a#", 11]],
  [["bb", 11], ["b", 12], ["b#", 1 ]]
].each do |note_letter_group|
  flat_note, note, sharp_note = note_letter_group
  flat_name, flat_value = flat_note
  name, value = note
  sharp_name, sharp_value = sharp_note

  Note.create!(name: flat_name,  letter: name, value: flat_value,  flat: true )
  Note.create!(name: name,       letter: name, value: value                   )
  Note.create!(name: sharp_name, letter: name, value: sharp_value, sharp: true)
end
