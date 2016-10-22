require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  def setup
    ::Data::Notes.create_all
  end

  def test_display_name
    test_names = [["cb", "C Flat"],["cbb", "C Double Flat"], ["e#", "E Sharp"], ["e##", "E Double Sharp"], ["a", "A"]]
    test_names.each do |name, expected_display_name|
      actual = Note.find_by(name: name).display_name
      assert_equal expected_display_name, actual, "Expected '#{expected_display_name}', but got #{actual}."
    end
  end

  def test_next_letter
    test_letters = [["c", "d"], ["d", "e"], ["e", "f"], ["f", "g"], ["g", "a"], ["a", "b"], ["b", "c"]]
    test_letters.each do |letter, next_letter|
      expected = next_letter
      [
        Note.find_by(letter: letter, flat: false, sharp: false).next_letter,
        Note.find_by(letter: letter, flat: true).next_letter,
        Note.find_by(letter: letter, sharp: true).next_letter
      ].each do |actual|
        assert_equal expected, actual, "Expected the letter after '#{letter}' to be '#{next_letter}', but got #{actual}"
      end
    end
  end

  def test_next_value
    test_values = [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 1]]
    test_values.each do |value, next_value|
      Note.where(value: value).each do |note|
        assert_equal next_value, note.next_value, "Expected the value after #{note.value} to be #{next_value}."
      end
    end
  end

  def test_whole_and_half_step
    test_notes = [["c", "db", "d"],["b#", "c#", "c##"],["fb", "gbb", "gb"],["a", "bb", "b"],["b", "c", "c#"]]
    test_notes.each do |note_letter, half_step_letter, whole_step_letter|
        note = Note.find_by(name: note_letter)
        half_step_from_note = Note.find_by(name: half_step_letter)
        whole_step_from_note = Note.find_by(name: whole_step_letter)
        assert_equal note.half_step.id, half_step_from_note.id, "Expected '#{half_step_letter}' to be a half step up from '#{note_letter}', but got '#{half_step_from_note.name}'"
        assert_equal note.whole_step.id, whole_step_from_note.id, "Expected '#{whole_step_letter}' to be a whole step up from '#{note_letter}', but got '#{whole_step_from_note.name}'"
      end
  end

  def test_major_third
      test_notes = [["c", "e"], ["d", "f#"], ["e", "g#"], ["f", "a"], ["g", "b"], ["a", "c#"], ["b", "d#"]]
      test_notes.each do |note, major_third_note|
        note = Note.find_by(name: note)
        expected = Note.find_by(name: major_third_note)
        actual = note.major_third
        assert_equal expected.id, actual.id, "Expected '#{major_third_note}' to be a major thrid above '#{note.name}', but got '#{actual.name}'"
      end
  end

  def test_minor_third
    test_notes = [["c", "eb"], ["d", "f"], ["e", "g"], ["f", "ab"], ["g", "bb"], ["a", "c"], ["b", "d"]]
    test_notes.each do |note, minor_third_note|
      note = Note.find_by(name: note)
      expected = Note.find_by(name: minor_third_note)
      actual = note.minor_third
      assert_equal expected.id, actual.id, "Expected '#{minor_third_note}' to be a minor thrid above '#{note.name}', but got '#{actual.name}'"
    end
  end

  def test_perfect_fifth
    test_notes = [["c", "g"], ["g", "d"], ["e", "b"], ["b", "f#"], ["a", "e"], ["f", "c"], ["gb", "db"]]
    test_notes.each do |note, perfect_fifth_note|
      note = Note.find_by(name: note)
      expected = Note.find_by(name: perfect_fifth_note)
      actual = note.perfect_fifth
      assert_equal expected, actual, "Expected '#{perfect_fifth_note}' to be a perfect fifth above '#{note.name}', but got '#{actual.name}'"
    end
  end

  def test_diminished_fifth
    test_notes = [["c", "gb"], ["g", "db"], ["e", "bb"], ["b", "f"], ["a", "eb"], ["f", "cb"], ["gb", "dbb"]]
    test_notes.each do |note, diminished_fifth_note|
      note = Note.find_by(name: note)
      expected = Note.find_by(name: diminished_fifth_note)
      actual = note.diminished_fifth
      assert_equal expected, actual, "Expected '#{diminished_fifth_note}' to be a diminished fifth above '#{note.name}', but got '#{actual.name}'"
    end
  end

  def next_value_test_helper(value, next_value)
    Note.where(value: value).each do |note|
      assert_equal next_value, note.next_value, "Expected the value after #{note.value} to be #{next_value}."
    end
  end
end
