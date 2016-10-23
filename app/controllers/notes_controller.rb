class NotesController < ApplicationController
  def index
    @notes = Note.to_display
  end

  def show
    @note = Note.find params[:id]
    @chords = @note.chords.map{ |chord| ChordViewData.fretboard(chord[:name], chord[:notes]) }
  end
end
