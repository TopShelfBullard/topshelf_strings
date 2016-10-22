class Note < ActiveRecord::Base
  def display_name
    "#{letter.upcase}#{display_accidental}"
  end

  private

  def display_accidental
    return "" unless flat || sharp
    flat ? " Flat" : " Sharp"
  end
end
