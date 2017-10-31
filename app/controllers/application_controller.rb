class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_options_for_instrument_select, :set_instrument, :set_notes_for_nav

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

  private

  def set_options_for_instrument_select
    @instrument_options ||= INSTRUMENTS.map{ |key, instrument| [instrument[:display_name], key] }
  end

  def set_instrument
    if params[:instrument].present?
      session[:instrument] = INSTRUMENTS[params[:instrument]]
    else
      session[:instrument] = INSTRUMENTS[DEFAULT_INSTRUMENT_KEY] unless session[:instrument]
    end
    @instrument = session[:instrument].symbolize_keys!
  end

  def set_notes_for_nav
    @notes_for_nav = Note.to_display
  end
end
