class NotesController < ApplicationController
  def index
    @notes = Note.to_display
  end

  def show
    @note = Note.find params[:id]
    @chords = @note.chords.map{ |chord| ChordViewData.fretboard(chord[:name], chord[:notes]) }
    @major = @note.major_scale
    @minor = @note.minor_scale
  end
end
