class ChordViewData
  def self.build_chord_view(note, instrument)
    {
      title:  chord_group_label(note),
      data: {
        chords: chord_group_chords(note, instrument)
      }
    }
  end

  def self.build_scale_chord_view(scale, instrument)
    data = scale[:notes].map do |note|
      {
        label:  scale_chord_group_label(note),
        chords: scale_chord_group_chords(note, scale, instrument),
      }
    end

    { title: scale_chord_group_title(scale), data: data }
  end

  private

  def self.chord_group_label(note)
    "Chords for #{note.display_name}:"
  end

  def self.chord_group_chords(note, instrument)
    note.chords.map{ |chord| fretboard(chord[:name], chord[:notes], instrument) }
  end

  def self.scale_chord_group_title(scale)
    "Chords Diatonic to the #{scale[:notes].first.display_name} #{scale[:type]} Scale"
  end

  def self.scale_chord_group_label(note)
    "#{note.display_name} Chords:"
  end

  def self.scale_chord_group_chords(note, scale, instrument)
    note.chords_diatonic_to(scale[:notes]).map{ |chord| fretboard(chord[:name], chord[:notes], instrument) }
  end

  def self.fretboard(label, notes, instrument)
    fretboard = { label: label, open_strings: instrument[:open_string_values], frets: [] }
    fouth, third, second, first = fretboard[:open_strings]

    0.upto(instrument[:number_of_frets]) {
      current_fret = [ nil, nil, nil, nil ]

      notes.each do |note|
        current_fret[0] = note.display_name if note.value == fouth
        current_fret[1] = note.display_name if note.value == third
        current_fret[2] = note.display_name if note.value == second
        current_fret[3] = note.display_name if note.value == first
      end

      fretboard[:frets] << current_fret

      fouth, third, second, first = up_half_step([ fouth, third, second, first ])
    }
    fretboard
  end

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