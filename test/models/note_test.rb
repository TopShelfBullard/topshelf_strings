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

  def test_perfect_fourth
    test_notes = [["c", "f"], ["g", "c"], ["e", "a"], ["b", "e"], ["a", "d"], ["f", "bb"], ["gb", "cb"]]
    test_notes.each do |note, perfect_fourth_note|
      note = Note.find_by(name: note)
      expected = Note.find_by(name: perfect_fourth_note)
      actual = note.perfect_fourth
      assert_equal expected, actual, "Expected '#{perfect_fourth_note}' to be a perfect fourth above '#{note.name}', but got '#{actual.name}'"
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

  def test_perfect_fifth
    test_notes = [["c", "g"], ["g", "d"], ["e", "b"], ["b", "f#"], ["a", "e"], ["f", "c"], ["gb", "db"]]
    test_notes.each do |note, perfect_fifth_note|
      note = Note.find_by(name: note)
      expected = Note.find_by(name: perfect_fifth_note)
      actual = note.perfect_fifth
      assert_equal expected, actual, "Expected '#{perfect_fifth_note}' to be a perfect fifth above '#{note.name}', but got '#{actual.name}'"
    end
  end

  def test_intervals
    tonic = Note.find_by(name: "c")
    test_intervals = [
      ["db", "half_step"],
      ["d",  "whole_step"],
      ["eb", "minor_third"],
      ["e",  "major_third"],
      ["f",  "perfect_fourth"],
      ["gb", "diminished_fifth"],
      ["g",  "perfect_fifth"],
      ["ab", "minor_sixth"],
      ["a",  "major_sixth"],
      ["a",  "diminished_seventh"],
      ["bb", "minor_seventh"],
      ["b",  "major_seventh"]
    ]
    test_intervals.each do |expected, interval_method|
      actual = tonic.send(interval_method).name
      assert_equal expected, actual, "Expected #{interval_method} for '#{tonic.name}'to be '#{expected}', but got '#{actual}'"
    end

    tonic = Note.find_by(name: "cb")
    test_intervals = [
      ["dbb", "half_step"],
      ["db",  "whole_step"],
      ["ebb", "minor_third"],
      ["eb",  "major_third"],
      ["fb",  "perfect_fourth"],
      ["gbb", "diminished_fifth"],
      ["gb",  "perfect_fifth"],
      ["abb", "minor_sixth"],
      ["ab",  "major_sixth"],
      ["ab",  "diminished_seventh"],
      ["bbb", "minor_seventh"],
      ["bb",  "major_seventh"]
    ]
    test_intervals.each do |expected, interval_method|
      actual = tonic.send(interval_method).name
      assert_equal expected, actual, "Expected #{interval_method} for '#{tonic.name}'to be '#{expected}', but got '#{actual}'"
    end

    tonic = Note.find_by(name: "c#")
    test_intervals = [
      ["d", "half_step"],
      ["d#",  "whole_step"],
      ["e", "minor_third"],
      ["e#",  "major_third"],
      ["f#",  "perfect_fourth"],
      ["g", "diminished_fifth"],
      ["g#",  "perfect_fifth"],
      ["a", "minor_sixth"],
      ["a#",  "major_sixth"],
      ["a#",  "diminished_seventh"],
      ["b", "minor_seventh"],
      ["b#",  "major_seventh"]
    ]
    test_intervals.each do |expected, interval_method|
      actual = tonic.send(interval_method).name
      assert_equal expected, actual, "Expected #{interval_method} for '#{tonic.name}'to be '#{expected}', but got '#{actual}'"
    end

    tonic = Note.find_by(name: "g")
    test_intervals = [
      ["ab", "half_step"],
      ["a",  "whole_step"],
      ["bb", "minor_third"],
      ["b",  "major_third"],
      ["c",  "perfect_fourth"],
      ["db", "diminished_fifth"],
      ["d",  "perfect_fifth"],
      ["eb", "minor_sixth"],
      ["e",  "major_sixth"],
      ["e",  "diminished_seventh"],
      ["f",  "minor_seventh"],
      ["f#", "major_seventh"]
    ]
    test_intervals.each do |expected, interval_method|
      actual = tonic.send(interval_method).name
      assert_equal expected, actual, "Expected #{interval_method} for '#{tonic.name}'to be '#{expected}', but got '#{actual}'"
    end
  end
  end
end
