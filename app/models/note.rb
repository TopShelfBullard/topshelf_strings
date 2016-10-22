class Note < ActiveRecord::Base
  validates :name, uniqueness: true

  scope :to_display, -> { where(double_flat: false, double_sharp: false) }

  NEXT_LETTERS = {
    "c" => "d",
    "d" => "e",
    "e" => "f",
    "f" => "g",
    "g" => "a",
    "a" => "b",
    "b" => "c"
  }

  def display_name
    "#{letter.upcase}#{display_accidental}"
  end

  def half_step
    Note.find_by(letter: next_letter, value: next_value)
  end

  def whole_step
    Note.find_by(letter: next_letter, value: next_value(2))
  end

  def minor_third
    Note.find_by(letter: next_letter_by(2), value: next_value(3))
  end

  def major_third
    Note.find_by(letter: next_letter_by(2), value: next_value(4))
  end

  def diminished_fifth
    minor_third.minor_third
  end

  def perfect_fifth
    major_third.minor_third
  end

  def next_letter_by(amount, current_letter = nil)
    current_letter ||= letter
    return current_letter unless amount > 0
    next_letter_by(amount - 1, next_letter(current_letter))
  end

  def next_letter(current_letter = nil)
    current_letter ? NEXT_LETTERS[current_letter] : NEXT_LETTERS[letter]
  end

  def next_value(step = 1)
    new_value = value + step
    new_value > 12 ? new_value - 12 : new_value
  end

  def display_accidental
    return "" unless flat || sharp || double_flat || double_sharp
    return " Flat" if flat
    return " Sharp" if sharp
    return " Double Flat" if double_flat
    return " Double Sharp" if double_sharp
  end
end
