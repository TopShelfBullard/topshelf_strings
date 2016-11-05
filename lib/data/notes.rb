class Data::Notes
  RAW_NOTE_DATA = [
    [ ["cbb", 11], ["cb", 12], ["c", 1 ], ["c#", 2 ], ["c##", 3  ] ],
    [ ["dbb", 1 ], ["db", 2 ], ["d", 3 ], ["d#", 4 ], ["d##", 5  ] ],
    [ ["ebb", 3 ], ["eb", 4 ], ["e", 5 ], ["e#", 6 ], ["e##", 7  ] ],
    [ ["fbb", 4 ], ["fb", 5 ], ["f", 6 ], ["f#", 7 ], ["f##", 8  ] ],
    [ ["gbb", 6 ], ["gb", 7 ], ["g", 8 ], ["g#", 9 ], ["g##", 10 ] ],
    [ ["abb", 8 ], ["ab", 9 ], ["a", 10], ["a#", 11], ["a##", 12 ] ],
    [ ["bbb", 10], ["bb", 11], ["b", 12], ["b#", 1 ], ["b##", 2  ] ]
  ]
  NEXT_LETTERS = { "c" => "d", "d" => "e", "e" => "f", "f" => "g", "g" => "a", "a" => "b", "b" => "c" }
  FLAT = "♭"
  DOUBLE_FLAT = "♭♭"
  SHARP = "♯"
  DOUBLE_SHARP = "♯♯"

  def self.create_all(verbose = false)
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    destroy_current_notes(verbose) if Note.count > 0
    create_all_notes_from_raw_data(verbose)
    add_missing_data_to_notes(verbose)
    display_results if verbose

    ActiveRecord::Base.logger = old_logger
  end

  def self.destroy_current_notes(verbose)
    puts "\nRemoving #{Note.count} current notes..." if verbose
    Note.destroy_all
    Note.connection_pool.with_connection{ |connection| connection.execute("TRUNCATE TABLE notes RESTART IDENTITY;") }

    raise "Unable to delete notes!" if Note.count > 0
    puts "Successfully deleted all notes from the notes table.\n\n" if verbose
  end

  def self.create_all_notes_from_raw_data(verbose)
    puts "\nCreating notes from raw note data...\n\n" if verbose
    RAW_NOTE_DATA.each{ |note_letter_group| create_notes_for(note_letter_group, verbose) }
    puts "\nSuccessfully created  notes from raw note data.\n\n" if verbose
  end

  def self.add_missing_data_to_notes(verbose)
    puts "\nAdding missing data to all notes...\n\n" if verbose
    Note.all.each{ |note| add_missing_data_to(note, verbose) }
    puts "\nSuccessfully added missing data to all notes.\n\n" if verbose
  end

  def self.display_results
    puts "\nSuccessfully created #{Note.count} notes: #{Note.pluck(:display_name).join(", ")}"
    puts "Notes fit for display: #{Note.to_display.map{ |note| note.display_name }.join(", ")}\n\n"
  end

  private

  def self.create_notes_for(note_letter_group, verbose)
    double_flat_note, flat_note, note, sharp_note, double_sharp_note = note_letter_group

    double_flat_name,  double_flat_value  = double_flat_note
    flat_name,         flat_value         = flat_note
    name,              value              = note
    sharp_name,        sharp_value        = sharp_note
    double_sharp_name, double_sharp_value = double_sharp_note

    note_names = "#{double_flat_name} #{flat_name} #{name} #{sharp_name} #{double_sharp_name}"

    puts "  Creating #{note_names}..." if verbose
    Note.create!( name: double_flat_name,  letter: name, value: double_flat_value,  double_flat: true  )
    Note.create!( name: flat_name,         letter: name, value: flat_value,         flat: true         )
    Note.create!( name: name,              letter: name, value: value                                  )
    Note.create!( name: sharp_name,        letter: name, value: sharp_value,        sharp: true        )
    Note.create!( name: double_sharp_name, letter: name, value: double_sharp_value, double_sharp: true )
    puts "  Successfully created #{note_names}." if verbose
  end

  def self.create_note_with_attributes(attrs)
    Note.create!( attrs )
  end

  def self.add_missing_data_to(note, verbose)
    puts "  Adding missing data to #{note.name}..." if verbose
    add_display_name_to(note)
    add_intervals_to(note)
    puts "  Successfully added display name and intervals to #{note.display_name}" if note.save! && verbose
  end

  def self.add_display_name_to(note)
    note.display_name = display_name(note)
  end

  def self.add_intervals_to(note)
    note.half_step = half_step_for_note(note)
    note.whole_step = whole_step_for_note(note)
    note.minor_third = minor_third_for_note(note)
    note.major_third = major_third_for_note(note)
    note.perfect_fourth = perfect_fourth_for_note(note)
    note.augmented_fourth = augmented_fourth_for_note(note)
    note.diminished_fifth = diminished_fifth_for_note(note)
    note.perfect_fifth = perfect_fifth_for_note(note)
    note.augmented_fifth = augmented_fifth_for_note(note)
    note.minor_sixth = minor_sixth_for_note(note)
    note.major_sixth = major_sixth_for_note(note)
    note.diminished_seventh = diminished_seventh_for_note(note)
    note.minor_seventh = minor_seventh_for_note(note)
    note.major_seventh = major_seventh_for_note(note)
  end

  def self.half_step_for_note(note)
    new_note = Note.find_by(letter: next_letter(note), value: next_value(note))
    new_note || Note.where(value: next_value(note)).first
  end

  def self.whole_step_for_note(note)
    new_note = Note.find_by(letter: next_letter(note), value: next_value(note, 2))
    new_note || Note.where(value: next_value(note, 2)).first
  end

  def self.minor_third_for_note(note)
    new_note = Note.find_by(letter: next_letter_by(note, 2), value: next_value(note, 3))
    new_note || Note.where(value: next_value(note, 3)).first
  end

  def self.major_third_for_note(note)
    new_note = Note.find_by(letter: next_letter_by(note, 2), value: next_value(note, 4))
    new_note || Note.where(value: next_value(note, 4)).first
  end

  def self.perfect_fourth_for_note(note)
    new_note = Note.find_by(letter: next_letter_by(note, 3), value: next_value(note, 5))
    new_note || Note.where(value: next_value(note, 5)).first
  end

  def self.augmented_fourth_for_note(note)
    new_note = Note.find_by(letter: next_letter_by(note, 3), value: next_value(note, 6))
    new_note || Note.where(value: next_value(note, 6)).first
  end

  def self.diminished_fifth_for_note(note)
    new_note = Note.find_by(letter: next_letter_by(note, 4), value: next_value(note, 6))
    new_note || Note.where(value: next_value(note, 6)).first
  end

  def self.perfect_fifth_for_note(note)
    new_note = Note.find_by(letter: next_letter_by(note, 4), value: next_value(note, 7))
    new_note || Note.where(value: next_value(note, 7)).first
  end

  def self.augmented_fifth_for_note(note)
    new_note = Note.find_by(letter: next_letter_by(note, 4), value: next_value(note, 8))
    new_note || Note.where(value: next_value(note, 8)).first
  end

  def self.minor_sixth_for_note(note)
    new_note = Note.find_by(letter: next_letter_by(note, 5), value: next_value(note, 8))
    new_note || Note.where(value: next_value(note, 8)).first
  end

  def self.major_sixth_for_note(note)
    new_note = Note.find_by(letter: next_letter_by(note, 5), value: next_value(note, 9))
    new_note || Note.where(value: next_value(note, 9)).first
  end

  def self.diminished_seventh_for_note(note)
    note.major_sixth
  end

  def self.minor_seventh_for_note(note)
    new_note = Note.find_by(letter: next_letter_by(note, 6), value: next_value(note, 10))
    new_note || Note.where(value: next_value(note, 10)).first
  end

  def self.major_seventh_for_note(note)
    new_note = Note.find_by(letter: next_letter_by(note, 6), value: next_value(note, 11))
    new_note || Note.where(value: next_value(note, 11)).first
  end

  def self.display_name(note)
    "#{note.letter.upcase}#{display_accidental(note)}"
  end

  def self.next_letter_by(note, amount, current_letter = nil)
    current_letter ||= note.letter
    return current_letter unless amount > 0
    next_letter_by(note, amount - 1, next_letter(note, current_letter))
  end

  def self.next_letter(note, current_letter = nil)
    current_letter ? NEXT_LETTERS[current_letter] : NEXT_LETTERS[note.letter]
  end

  def self.next_value(note, step = 1)
    new_value = note.value + step
    new_value > 12 ? new_value - 12 : new_value
  end

  def self.display_accidental(note)
    return "" unless note.flat || note.sharp || note.double_flat || note.double_sharp
    return FLAT if note.flat
    return SHARP if note.sharp
    return DOUBLE_FLAT if note.double_flat
    return DOUBLE_SHARP if note.double_sharp
  end
end