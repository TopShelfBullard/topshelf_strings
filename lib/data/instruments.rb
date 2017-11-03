class Data::Instruments
  def self.create_all
    destroy_current_instruments
    create_new_instruments
  end

  def self.destroy_current_instruments
    Instrument.destroy_all
    Instrument.connection_pool.with_connection{ |connection| connection.execute("TRUNCATE TABLE instruments RESTART IDENTITY;") }
    raise "Unable to instruments notes!" if Instrument.count > 0
  end

  def self.create_new_instruments
    Instrument.create!(
      value: "soprano_ukulele",
      display_name: "soprano ukulele",
      number_of_frets: 12,
      number_of_strings: 4,
      open_string_values: [8, 1, 5, 10]
    )

    Instrument.create!(
      value: "concert_ukulele",
      display_name: "concert ukulele",
      number_of_frets: 18,
      number_of_strings: 4,
      open_string_values: [8, 1, 5, 10]
    )

    Instrument.create!(
      value: "tenor_ukulele",
      display_name: "tenor ukulele",
      number_of_frets: 18,
      number_of_strings: 4,
      open_string_values: [8, 1, 5, 10]
    )

    Instrument.create!(
      value: "baritone_ukulele",
      display_name: "baritone ukulele",
      number_of_frets: 20,
      number_of_strings: 4,
      open_string_values: [3, 8, 12, 5]
    )
  end
end