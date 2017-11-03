require "#{Rails.root}/lib/data/chord_view_data.rb"
require "#{Rails.root}/lib/data/fretboard.rb"

class StaticAppData
  INSTRUMENTS = {
    "soprano_ukulele" => {
      value: "soprano_ukulele",
      display_name: "soprano ukulele",
      number_of_frets: 12,
      number_of_strings: 4,
      open_string_values: [8, 1, 5, 10]
    },
    "concert_ukulele" => {
      value: "concert_ukulele",
      display_name: "concert ukulele",
      number_of_frets: 18,
      number_of_strings: 4,
      open_string_values: [8, 1, 5, 10]
    },
    "tenor_ukulele" => {
      value: "tenor_ukulele",
      display_name: "tenor ukulele",
      number_of_frets: 18,
      number_of_strings: 4,
      open_string_values: [8, 1, 5, 10]
    },
    "baritone_ukulele" => {
      value: "baritone_ukulele",
      display_name: "baritone ukulele",
      number_of_frets: 20,
      number_of_strings: 4,
      open_string_values: [3, 8, 12, 5]
    }
  }

  DEFAULT_INSTRUMENT_KEY = "soprano_ukulele"

  def self.initialize_data
    notes
    scales
    instruments
    default_instrument
    all_chord_view_data
  end

  def self.instruments
    @@instruments ||= INSTRUMENTS
  end

  def self.default_instrument
    @@instruments[DEFAULT_INSTRUMENT_KEY]
  end

  def self.notes
    @@notes ||= Note.to_display
  end

  def self.scales
    @@scales ||= Note::SCALES
  end

  def self.all_chord_view_data
    @@all_chord_view_data ||= Hash[
      notes.map { |note|
        [
          note.name.to_sym,
          Hash[
            instruments.map{ |instrument_key, instrument|
              [
                instrument_key.to_sym,
                ChordViewData.chord_view_data_for(note, instrument)
              ]
            }
          ]
        ]
      }
    ]
  end
end
