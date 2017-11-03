require "#{Rails.root}/lib/data/chord_view_data.rb"
require "#{Rails.root}/lib/data/fretboard.rb"

class StaticAppData
  def self.initialize_data
    notes
    scales
    default_instrument
    all_chord_view_data
  end

  def self.default_instrument
    @@default_instrument ||= Instrument.first
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
            Instrument.all.map{ |instrument|
              [
                instrument.value.to_sym,
                ChordViewData.chord_view_data_for(note, instrument)
              ]
            }
          ]
        ]
      }
    ]
  end
end
