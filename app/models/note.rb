class Note < ActiveRecord::Base
  validates :name, uniqueness: true

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

  def half_step_up
    Note.find_by(letter: next_letter, value: next_value)
  end

  def whole_step_up
    Note.find_by(letter: next_letter, value: next_value(2))
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
    return value + step if value < 12
    (value - 12) + step
  end

  private

  def display_accidental
    return "" unless flat || sharp || double_flat || double_sharp
    return " Flat" if flat
    return " Sharp" if sharp
    return " Double Flat" if double_flat
    return " Double Sharp" if double_sharp
  end
end
