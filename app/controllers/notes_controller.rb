class NotesController < ApplicationController
  def index
    @notes = Note.to_display
  end

  def show
    @note = Note.find params[:id]
    @notes = StaticAppData.notes
    @scales = StaticAppData.scales
    @chord_views = StaticAppData.all_chord_view_data[@note.name.to_sym][@instrument.value.to_sym]
    @all_chords = @chord_views[:all_chords]
  end
end
