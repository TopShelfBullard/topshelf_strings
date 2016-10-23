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

  FLAT = "♭"
  DOUBLE_FLAT = "♭♭"
  SHARP = "♯"
  DOUBLE_SHARP = "♯♯"

  def chords
    [
      major,  minor, diminished, augmented, five, six, min_six,  min_min_six, seventh, maj_seventh, min_maj_seventh,
      min_seventh, aug_maj_seventh, aug_seventh, half_dim_seventh, dim_seventh, seventh_flat_five, add_nine, min_add_nine,
      sus_two ,sus_four,
    ]
  end

  def major
    {
      name: display_chord_name("M"),
      notes: [ self, major_third, perfect_fifth ]
    }
  end

  def minor
    {
      name: display_chord_name("m"),
      notes: [ self, minor_third, perfect_fifth ]
    }
  end

  def diminished
    {
      name: display_chord_name("dim"),
      notes: [ self, minor_third, diminished_fifth ]
    }
  end

  def augmented
    {
      name: display_chord_name("aug"),
      notes: [ self, major_third, augmented_fifth ]
    }
  end

  def five
    {
      name: display_chord_name("5"),
      notes: [ self, perfect_fifth ]
    }
  end

  def six
    {
      name: display_chord_name("6"),
      notes: [ self, major_third, perfect_fifth , major_sixth ]
    }
  end

  def min_six
    {
      name: display_chord_name("m6"),
      notes: [ self, minor_third, perfect_fifth , major_sixth ]
    }
  end

  def min_min_six
    {
      name: display_chord_name("min<sup>min6</sup>"),
      notes: [self, minor_third, perfect_fifth, minor_sixth]
    }
  end

  def seventh
    {
      name: display_chord_name("<sup>7</sup>"),
      notes: [self, major_third, perfect_fifth, minor_seventh]
    }
  end

  def maj_seventh
    {
      name: display_chord_name("maj<sup>7</sup>"),
      notes: [self, major_third, perfect_fifth, major_seventh]
    }
  end

  def min_maj_seventh
    {
      name: display_chord_name("min<sup>maj7</sup>"),
      notes: [self, minor_third, perfect_fifth, major_seventh]
    }
  end

  def min_seventh
    {
      name: display_chord_name("min<sup>7</sup>"),
      notes: [self, minor_third, perfect_fifth, minor_seventh]
    }
  end

  def aug_maj_seventh
    {
      name: display_chord_name("aug<sup>maj7</sup>"),
      notes: [self, major_third, augmented_fifth, major_seventh]
    }
  end

  def aug_seventh
    {
      name: display_chord_name("aug<sup>7</sup>"),
      notes: [self, major_third, augmented_fifth, minor_seventh]
    }
  end

  def half_dim_seventh
    {
      name: display_chord_name("min<sup>7dim5</sup>"),
      notes: [self, minor_third, diminished_fifth, minor_seventh]
    }
  end

  def dim_seventh
    {
      name: display_chord_name("dim<sup>7</sup>"),
      notes: [self, minor_third, diminished_fifth, diminished_seventh]
    }
  end

  def seventh_flat_five
    {
      name: display_chord_name("7<sup>♭5</sup>"),
      notes: [self, major_third, diminished_fifth, minor_seventh]
    }
  end

  def add_nine
    {
      name: display_chord_name("add9"),
      notes: [self, whole_step, major_third, perfect_fifth]
    }
  end

  def min_add_nine
    {
      name: display_chord_name("madd9"),
      notes: [self, whole_step, minor_third, perfect_fifth]
    }
  end

  def sus_two
    {
      name: display_chord_name("sus2"),
      notes: [self, whole_step, perfect_fifth]
    }
  end

  def sus_four
    {
      name: display_chord_name("sus4"),
      notes: [self, perfect_fourth, perfect_fifth]
    }
  end

  def display_name
    "#{letter.upcase}#{display_accidental}"
  end

  def half_step
    note = Note.find_by(letter: next_letter, value: next_value)
    note || Note.where(value: next_value).first
  end

  def whole_step
    note = Note.find_by(letter: next_letter, value: next_value(2))
    note || Note.where(value: next_value(2)).first
  end

  def minor_third
    note = Note.find_by(letter: next_letter_by(2), value: next_value(3))
    note || Note.where(value: next_value(3)).first
  end

  def major_third
    note = Note.find_by(letter: next_letter_by(2), value: next_value(4))
    note || Note.where(value: next_value(4)).first
  end

  def perfect_fourth
    note = Note.find_by(letter: next_letter_by(3), value: next_value(5))
    note || Note.where(value: next_value(5)).first
  end

  def diminished_fifth
    note = Note.find_by(letter: next_letter_by(4), value: next_value(6))
    note || Note.where(value: next_value(6)).first
  end

  def perfect_fifth
    note = Note.find_by(letter: next_letter_by(4), value: next_value(7))
    note || Note.where(value: next_value(7)).first
  end

  def augmented_fifth
    note = Note.find_by(letter: next_letter_by(4), value: next_value(8))
    note || Note.where(value: next_value(8)).first
  end

  def minor_sixth
    note = Note.find_by(letter: next_letter_by(5), value: next_value(8))
    note || Note.where(value: next_value(8)).first
  end

  def major_sixth
    note = Note.find_by(letter: next_letter_by(5), value: next_value(9))
    note || Note.where(value: next_value(9)).first
  end

  def diminished_seventh
    major_sixth
  end

  def minor_seventh
    note = Note.find_by(letter: next_letter_by(6), value: next_value(10))
    note || Note.where(value: next_value(10)).first
  end

  def major_seventh
    note = Note.find_by(letter: next_letter_by(6), value: next_value(11))
    note || Note.where(value: next_value(11)).first
  end

  private

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
    return FLAT if flat
    return SHARP if sharp
    return DOUBLE_FLAT if double_flat
    return DOUBLE_SHARP if double_sharp
  end

  def display_chord_name(chord_abbreviation)
    "#{display_name}#{chord_abbreviation}".html_safe
  end
end
