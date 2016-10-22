class NotesController < ApplicationController
  def index
    @notes = Note.to_display
  end

  def show
    @note = Note.find params[:id]
  end
end
