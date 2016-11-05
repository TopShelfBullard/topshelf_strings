require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  def setup
    ::Data::Notes.create_all
  end

  def test_display_name
    test_names = [["cb", "C♭"],["cbb", "C♭♭"], ["e#", "E♯"], ["e##", "E♯♯"], ["a", "A"]]
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

  def test_augmented_fourth
    test_notes = [["c", "f#"], ["g", "c#"], ["e", "a#"], ["b", "e#"], ["a", "d#"], ["f", "b"], ["gb", "c"]]
    test_notes.each do |note, perfect_fourth_note|
      note = Note.find_by(name: note)
      expected = Note.find_by(name: perfect_fourth_note)
      actual = note.augmented_fourth
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

  def test_major_chord
    chord_test_helper(["c","e","g"], "major")
  end

  def test_minor_chord
    chord_test_helper(["c","eb","g"], "minor")
  end

  def test_diminished_chord
    chord_test_helper(["c","eb","gb"], "diminished")
  end

  def test_five_chord
    chord_test_helper(["c","g"], "five")
  end

  def test_six_chord
    chord_test_helper(["c","e","g","a"], "six")
  end

  def test_augmented_chord
    chord_test_helper(["c","e","g#"], "augmented")
  end

  def test_min_sixth_chord
    chord_test_helper(["c","eb","g","a"], "min_six")
  end

  def test_min_min_sixth_chord
    chord_test_helper(["c","eb","g","ab"], "min_min_six")
  end

  def test_seventh_chord
    chord_test_helper(["c","e","g","bb"], "seventh")
  end

  def test_maj_seventh_chord
    chord_test_helper(["c","e","g","b"], "maj_seventh")
  end

  def test_min_maj_seventh_chord
    chord_test_helper(["c","eb","g","b"], "min_maj_seventh")
  end

  def test_min_seventh_chord
    chord_test_helper(["c","eb","g","bb"], "min_seventh")
  end

  def test_aug_maj_seventh_chord
    chord_test_helper(["c","e","g#","b"], "aug_maj_seventh")
  end

  def test_aug_seventh_chord
    chord_test_helper(["c","e","g#","bb"], "aug_seventh")
  end

  def test_half_dim_seventh_chord
    chord_test_helper(["c","eb","gb","bb"], "half_dim_seventh")
  end

  def test_dim_seventh_chord
    chord_test_helper(["c","eb","gb","a"], "dim_seventh")
  end

  def test_seventh_flat_five_chord
    chord_test_helper(["c","e","gb","bb"], "seventh_flat_five")
  end

  def test_add_nine_chord
    chord_test_helper(["c","d","e","g"], "add_nine")
  end

  def test_min_add_nine_chord
    chord_test_helper(["c","d","eb","g"], "min_add_nine")
  end

  def test_sus_two_chord
    chord_test_helper(["c","d","g"], "sus_two")
  end

  def test_sus_four_chord
    chord_test_helper(["c","f","g"], "sus_four")
  end

  def test_augmented_chord_notes
    note = Note.find_by(name: "b#")
    note.augmented[:notes].each{|n| refute n.nil? }
    note.aug_seventh[:notes].map{|n| refute n.nil? }
    note.aug_maj_seventh[:notes].map{|n| refute n.nil?}

    note = Note.find_by(name: "c#")
    note.augmented[:notes].each{|n| refute n.nil? }
    note.aug_seventh[:notes].map{|n| refute n.nil? }
    note.aug_maj_seventh[:notes].map{|n| refute n.nil?}
  end

  def test_major_scale
    c_major = [ "c", "d", "e", "f", "g", "a", "b" ]
    c = Note.find_by(name: c_major.first)
    assert_equal c.major_scale, c_major.map{ | note_name | Note.find_by(name: note_name) }
  end

  def test_minor_scale
    a_minor = [ "a", "b", "c", "d", "e", "f", "g" ]
    a = Note.find_by(name: a_minor.first)
    assert_equal a.minor_scale, a_minor.map{ | note_name | Note.find_by(name: note_name) }
  end

  def test_chord_is_diatonic_to
    c = Note.find_by(name: "c")
    assert c.chords_diatonic_to(c.major_scale).include?(c.major)
    assert c.chords_diatonic_to(c.major_scale).include?(c.maj_seventh)
    refute c.chords_diatonic_to(c.major_scale).include?(c.seventh)
    refute c.chords_diatonic_to(c.major_scale).include?(c.minor)
    assert c.chords_diatonic_to(c.minor_scale).include?(c.minor)
  end

  def chord_test_helper(expected_note_names, method_name)
    tonic = Note.find_by(name: expected_note_names.first)
    expected = expected_note_names.map{ |note_name| Note.find_by(name: note_name) }
    actual = tonic.send(method_name)[:notes]
    assert_equal expected, actual, chord_message(expected, actual)
  end

  def chord_message(expected_notes, actual_notes)
    expected_note_names = expected_notes.map{|ns| ns.name}
    actual_note_names = actual_notes.map{|ns| ns.name}
    "expected '#{expected_note_names.join(", ")}' - got '#{actual_note_names.join(", ")}'"
  end
end
