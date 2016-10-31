class NotesController < ApplicationController
  def index
    @notes = Note.to_display
  end

  def show
    @notes = Note.to_display
    @note = Note.find params[:id]
    @scales = Note::SCALES
    @chord_views = Hash[
      @scales.map { |scale_name|
        scale_type = scale_name.split("_").map{ |w| w.capitalize }.join(" ")
        [
          "#{scale_name}_key_chords".to_sym,
          ChordViewData.build_scale_chord_view(notes: @note.send("#{scale_name}_scale"), type: scale_type)
        ]
      }
    ].merge(all_chords: ChordViewData.build_chord_view(@note))
  end
end
