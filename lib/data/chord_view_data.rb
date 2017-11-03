class ChordViewData
  def self.chord_view_data_for(note, instrument)
    all_chords_for_root_note(note, instrument)
      .merge(
        chord_view_data_for_scales(note, instrument)
      )
  end

  def self.chord_view_data_for_scales(note, instrument)
    Hash[
      StaticAppData.scales.map { |scale_name|
        [
          "#{scale_name}_key_chords".to_sym,
          build_chord_views_for_scale(scale_data(note, scale_name), instrument)
        ]
      }
    ]
  end

  def self.build_chord_views_for_scale(scale, instrument)
    current_scale_name = "#{scale[:notes].first.display_name} #{scale[:type]}"
    {
      scale: {
        title: "Scale",
        data: [{
          label:  "#{current_scale_name} Scale",
          chords: [Fretboard.build("#{current_scale_name} Scale", scale[:notes], instrument)],
        }]
      },
      chords: {
        title: "Chords Diatonic to the #{current_scale_name} Scale",
        data: scale[:notes].map{ |note|
          {
            label:  "#{note.display_name} Chords:",
            chords: Fretboard.build_all(note.chords_diatonic_to(scale[:notes]), instrument),
          }
        }
      }
    }
  end

  def self.all_chords_for_root_note(note, instrument)
    {
      all_chords: {
        title:  "Chords for #{note.display_name}:",
        data: {
          label:  "Chords for #{note.display_name}:",
          chords: Fretboard.build_all(note.chords, instrument)
        }
      }
    }
  end

  def self.scale_data(note, scale_name)
    {
      notes: note.send("#{scale_name}_scale"),
      type: scale_name.split("_").map{ |w| w.capitalize }.join(" ")
    }
  end
end
