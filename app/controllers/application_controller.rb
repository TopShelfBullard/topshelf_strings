class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_options_for_instrument_select, :set_instrument, :set_notes_for_nav

  private

  def set_options_for_instrument_select
    @instrument_options ||= StaticAppData.instruments.map{ |key, instrument| [instrument[:display_name], key] }
  end

  def set_instrument
    if params[:instrument].present?
      session[:instrument] = StaticAppData.instruments[params[:instrument]]
    else
      session[:instrument] = StaticAppData.default_instrument
    end
    @instrument = session[:instrument].symbolize_keys!
  end

  def set_notes_for_nav
    @notes_for_nav = StaticAppData.notes
  end
end
