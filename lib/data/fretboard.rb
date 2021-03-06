class Fretboard
  def self.build_all(chords, instrument)
    chords.map{ |chord| build(chord[:name], chord[:notes], instrument) }
  end

  def self.build(label, notes, instrument)
    fretboard = { label: label, frets: [] }
    fourth, third, second, first = instrument.open_string_values

    0.upto(instrument.number_of_frets) {
      current_fret = [ nil, nil, nil, nil ]

      notes.each do |note|
        current_fret[0] = note.display_name if note.value == fourth
        current_fret[1] = note.display_name if note.value == third
        current_fret[2] = note.display_name if note.value == second
        current_fret[3] = note.display_name if note.value == first
      end

      fretboard[:frets] << current_fret
      fourth, third, second, first = up_half_step([ fourth, third, second, first ])
    }
    fretboard
  end

  private

  def self.add_one_under_twelve(current_value)
    new_value = current_value + 1
    new_value > 12 ? new_value - 12 : new_value
  end

  def self.up_half_step(fret)
    fouth_string, third_string, second_string, first_string = fret
    [
      add_one_under_twelve(fouth_string),
      add_one_under_twelve(third_string),
      add_one_under_twelve(second_string),
      add_one_under_twelve(first_string)
    ]
  end
end