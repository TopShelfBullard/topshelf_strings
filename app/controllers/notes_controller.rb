class NotesController < ApplicationController
  def index
    @notes = Note.to_display
  end

  def show
    require 'pp'
    @note = Note.find params[:id]
    @notes = Note.to_display
    @scales = Note::SCALES
    @chord_views = all_chord_view_data
  end

  private

  def all_chord_view_data
    chord_view_data_for_scales.merge(
      all_chords: ChordViewData.build_chord_view(@note, @instrument)
    )
  end

  def chord_view_data_for_note
    ChordViewData.build_chord_view(@note, @instrument)
  end

  def chord_view_data_for_scales
    Hash[
      @scales.map { |scale_name|
        [
          chord_group_key_for(scale_name),
          chord_view_data_for_note_scale(scale_name)
        ]
      }
    ]
  end

  def chord_view_data_for_note_scale(scale_name)
    ChordViewData.build_scale_chord_view(
      {
        notes: @note.send("#{scale_name}_scale"),
        type: scale_type_from(scale_name)
      },
      @instrument
    )
  end

  def scale_type_from(scale_name)
    scale_name.split("_").map{ |w| w.capitalize }.join(" ")
  end

  def chord_group_key_for(scale_name)
    "#{scale_name}_key_chords".to_sym
  end
end
