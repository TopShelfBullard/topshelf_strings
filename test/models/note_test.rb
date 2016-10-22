require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  def setup
    [
      [["cbb", 11], ["cb", 12], ["c", 1 ], ["c#", 2 ], ["c##", 3  ]],
      [["dbb", 1 ], ["db", 2 ], ["d", 3 ], ["d#", 4 ], ["d##", 5  ]],
      [["ebb", 3 ], ["eb", 4 ], ["e", 5 ], ["e#", 6 ], ["e##", 7  ]],
      [["fbb", 4 ], ["fb", 5 ], ["f", 6 ], ["f#", 7 ], ["f##", 8  ]],
      [["gbb", 6 ], ["gb", 7 ], ["g", 8 ], ["g#", 9 ], ["g##", 10 ]],
      [["abb", 8 ], ["ab", 9 ], ["a", 10], ["a#", 11], ["a##", 12 ]],
      [["bbb", 10], ["bb", 11], ["b", 12], ["b#", 1 ], ["b##", 2  ]]
    ].each do |note_letter_group|
      double_flat_note, flat_note, note, sharp_note, double_sharp_note = note_letter_group
      double_flat_name, double_flat_value = double_flat_note
      flat_name, flat_value = flat_note
      name, value = note
      sharp_name, sharp_value = sharp_note
      double_sharp_name, double_sharp_value = double_sharp_note

      Note.create!( name: double_flat_name,  letter: name, value: double_flat_value,  double_flat: true  )
      Note.create!( name: flat_name,         letter: name, value: flat_value,         flat: true         )
      Note.create!( name: name,              letter: name, value: value                                  )
      Note.create!( name: sharp_name,        letter: name, value: sharp_value,        sharp: true        )
      Note.create!( name: double_sharp_name, letter: name, value: double_sharp_value, double_sharp: true )
    end
  end

  def test_display_name
    expected = "C Flat"
    actual = Note.find_by(name: "cb").display_name
    assert_equal expected, actual, "Expected '#{expected}', but got #{actual}."

    expected = "C Double Flat"
    actual = Note.find_by(name: "cbb").display_name
    assert_equal expected, actual, "Expected '#{expected}', but got #{actual}."

    expected = "E Sharp"
    actual = Note.find_by(name: "e#").display_name
    assert_equal expected, actual, "Expected '#{expected}', but got #{actual}."

    expected = "E Double Sharp"
    actual = Note.find_by(name: "e##").display_name
    assert_equal expected, actual, "Expected '#{expected}', but got #{actual}."

    expected = "A"
    actual = Note.find_by(name: "a").display_name
    assert_equal expected, actual, "Expected '#{expected}', but got #{actual}."
  end

  def test_next_letter
    [
      ["c", "d"], ["d", "e"], ["e", "f"], ["f", "g"], ["g", "a"], ["a", "b"], ["b", "c"]
    ].each do |letter, next_letter|
      next_letter_test_helper(letter, next_letter)
    end
  end

  def test_next_value
    [
      [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 1]
    ].each do |value, next_value|
      next_value_test_helper(value, next_value)
    end
  end

  def test_whole_and_half_step_up
    whole_and_half_step_test_helper("c", "db", "d")
    whole_and_half_step_test_helper("b#", "c#", "c##")
    whole_and_half_step_test_helper("fb", "gbb", "gb")
    whole_and_half_step_test_helper("a", "bb", "b")
    whole_and_half_step_test_helper("b", "c", "c#")
  end

  def next_value_test_helper(value, next_value)
    Note.where(value: value).each do |note|
      assert_equal next_value, note.next_value, "Expected the value after #{note.value} to be #{next_value}."
    end
  end

  def next_letter_test_helper(letter, next_letter)
    expected = next_letter
    [
      Note.find_by(letter: letter, flat: false, sharp: false).next_letter,
      Note.find_by(letter: letter, flat: true).next_letter,
      Note.find_by(letter: letter, sharp: true).next_letter
    ].each do |actual|
      assert_equal expected, actual, "Expected the letter after '#{letter}' to be '#{next_letter}', but got #{actual}"
    end
  end

  def whole_and_half_step_test_helper(note_letter, half_step_up_letter, whole_step_up_letter)
    note = Note.find_by(name: note_letter)
    half_step_up_from_note = Note.find_by(name: half_step_up_letter)
    whole_step_up_from_note = Note.find_by(name: whole_step_up_letter)
    assert_equal note.half_step_up.id, half_step_up_from_note.id, "Expected '#{half_step_up_letter}' to be a half step up from '#{note_letter}', but got '#{half_step_up_from_note.name}'"
    assert_equal note.whole_step_up.id, whole_step_up_from_note.id, "Expected '#{whole_step_up_letter}' to be a whole step up from '#{note_letter}', but got '#{whole_step_up_from_note.name}'"
  end
end
