class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_instrument_id_in_session,
                :set_instrument,
                :set_options_for_instrument_select,
                :set_notes_for_nav

  private

  def set_options_for_instrument_select
    @instrument_options ||= Instrument.all.map{ |instrument| [instrument.display_name, instrument.id] }
  end

  def set_instrument_id_in_session
    puts params.inspect
    session[:instrument_id] = params[:instrument_id] if params[:instrument_id].present?
  end

  def set_instrument
    @instrument =
      if session[:instrument_id].present?
        Instrument.find(session[:instrument_id])
      else
        StaticAppData.default_instrument
      end
  end

  def set_notes_for_nav
    @notes_for_nav = StaticAppData.notes
  end
end
