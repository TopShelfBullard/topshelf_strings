class Note < ActiveRecord::Base
  belongs_to :half_step,           class_name: "Note", foreign_key: "half_step_id"
  has_many   :half_steps,          class_name: "Note", foreign_key: "half_step_id"

  belongs_to :whole_step,          class_name: "Note", foreign_key: "whole_step_id"
  has_many   :whole_steps,         class_name: "Note", foreign_key: "whole_step_id"

  belongs_to :minor_third,         class_name: "Note", foreign_key: "minor_third_id"
  has_many   :minor_thirds,        class_name: "Note", foreign_key: "minor_third_id"

  belongs_to :major_third,         class_name: "Note", foreign_key: "major_third_id"
  has_many   :major_thirds,        class_name: "Note", foreign_key: "major_third_id"

  belongs_to :perfect_fourth,      class_name: "Note", foreign_key: "perfect_fourth_id"
  has_many   :perfect_fourths,     class_name: "Note", foreign_key: "perfect_fourth_id"

  belongs_to :augmented_fourth,    class_name: "Note", foreign_key: "augmented_fourth_id"
  has_many   :augmented_fourths,   class_name: "Note", foreign_key: "augmented_fourth_id"

  belongs_to :diminished_fifth,    class_name: "Note", foreign_key: "diminished_fifth_id"
  has_many   :diminished_fifths,   class_name: "Note", foreign_key: "diminished_fifth_id"

  belongs_to :perfect_fifth,       class_name: "Note", foreign_key: "perfect_fifth_id"
  has_many   :perfect_fifths,      class_name: "Note", foreign_key: "perfect_fifth_id"

  belongs_to :augmented_fifth,     class_name: "Note", foreign_key: "augmented_fifth_id"
  has_many   :augmented_fifths,    class_name: "Note", foreign_key: "augmented_fifth_id"

  belongs_to :minor_sixth,         class_name: "Note", foreign_key: "minor_sixth_id"
  has_many   :minor_sixths,        class_name: "Note", foreign_key: "minor_sixth_id"

  belongs_to :major_sixth,         class_name: "Note", foreign_key: "major_sixth_id"
  has_many   :major_sixths,        class_name: "Note", foreign_key: "major_sixth_id"

  belongs_to :diminished_seventh,  class_name: "Note", foreign_key: "diminished_seventh_id"
  has_many   :diminished_sevenths, class_name: "Note", foreign_key: "diminished_seventh_id"

  belongs_to :minor_seventh,       class_name: "Note", foreign_key: "minor_seventh_id"
  has_many   :minor_sevenths,      class_name: "Note", foreign_key: "minor_seventh_id"

  belongs_to :major_seventh,       class_name: "Note", foreign_key: "major_seventh_id"
  has_many   :major_sevenths,      class_name: "Note", foreign_key: "major_seventh_id"

  validates :name, uniqueness: true

  scope :to_display, -> {
    self.include_associates.where(double_flat: false, double_sharp: false)
  }

  scope :include_associates, -> {
    includes(
      :half_step, :whole_step, :minor_third, :major_third, :perfect_fourth, :augmented_fourth, :diminished_fifth,
      :perfect_fifth, :augmented_fifth, :minor_sixth, :major_sixth, :diminished_seventh,
      :minor_seventh, :major_seventh
    )
  }

  SCALES = [
    "major",
    "minor",
    "dorian",
    "phrygian",
    "lydian",
    "mixolydian",
    "locrian",
    "whole_tone"
  ]

  def chords
    @major || [
      major, minor, diminished, augmented, five, six, min_six,  min_min_six, seventh, maj_seventh, min_maj_seventh,
      min_seventh, aug_maj_seventh, aug_seventh, half_dim_seventh, dim_seventh, seventh_flat_five, add_nine, min_add_nine,
      sus_two ,sus_four
    ]
  end

  def chords_diatonic_to(scale)
    scale_values = scale.map{ |note| note.value }
    chords.select{ |chord|
      diatonic = true
      chord[:notes].map{ |note| note.value }.each do |value|
        diatonic = false unless scale_values.include?(value)
      end
      diatonic
    }
  end

  def major_scale
    [ self, whole_step, major_third, perfect_fourth, perfect_fifth, major_sixth, major_seventh ]
  end

  def dorian_scale
    [ self, whole_step, minor_third, perfect_fourth, perfect_fifth, major_sixth, minor_seventh ]
  end

  def phrygian_scale
    [ self, half_step,  minor_third, perfect_fourth, perfect_fifth, minor_sixth, minor_seventh ]
  end

  def lydian_scale
    [ self, whole_step, major_third, augmented_fourth, perfect_fifth, major_sixth, major_seventh ]
  end

  def mixolydian_scale
    [ self, whole_step, major_third, perfect_fourth, perfect_fifth, major_sixth, minor_seventh ]
  end

  def minor_scale
    [ self, whole_step, minor_third, perfect_fourth, perfect_fifth, minor_sixth, minor_seventh ]
  end

  def locrian_scale
    [ self, half_step,  minor_third, perfect_fourth, diminished_fifth, minor_sixth, minor_seventh ]
  end

  def whole_tone_scale
    [ self, whole_step, major_third, augmented_fourth, augmented_fifth, minor_seventh ]
  end

  def major
    @major || {
      name: display_chord_name("M"),
      notes: [ self, major_third, perfect_fifth ]
    }
  end

  def minor
    @minor || {
      name: display_chord_name("m"),
      notes: [ self, minor_third, perfect_fifth ]
    }
  end

  def diminished
    @diminished || {
      name: display_chord_name("dim"),
      notes: [ self, minor_third, diminished_fifth ]
    }
  end

  def augmented
    @augmented || {
      name: display_chord_name("aug"),
      notes: [ self, major_third, augmented_fifth ]
    }
  end

  def five
    @five || {
      name: display_chord_name("5"),
      notes: [ self, perfect_fifth ]
    }
  end

  def six
    @six || {
      name: display_chord_name("6"),
      notes: [ self, major_third, perfect_fifth , major_sixth ]
    }
  end

  def min_six
    @min_six || {
      name: display_chord_name("m6"),
      notes: [ self, minor_third, perfect_fifth , major_sixth ]
    }
  end

  def min_min_six
    @min_min_six || {
      name: display_chord_name("min<sup>min6</sup>"),
      notes: [self, minor_third, perfect_fifth, minor_sixth]
    }
  end

  def seventh
    @seventh || {
      name: display_chord_name("<sup>7</sup>"),
      notes: [self, major_third, perfect_fifth, minor_seventh]
    }
  end

  def maj_seventh
    @maj_seventh || {
      name: display_chord_name("maj<sup>7</sup>"),
      notes: [self, major_third, perfect_fifth, major_seventh]
    }
  end

  def min_maj_seventh
    @min_maj_seventh || {
      name: display_chord_name("min<sup>maj7</sup>"),
      notes: [self, minor_third, perfect_fifth, major_seventh]
    }
  end

  def min_seventh
    @min_seventh || {
      name: display_chord_name("min<sup>7</sup>"),
      notes: [self, minor_third, perfect_fifth, minor_seventh]
    }
  end

  def aug_maj_seventh
    @aug_maj_seventh || {
      name: display_chord_name("aug<sup>maj7</sup>"),
      notes: [self, major_third, augmented_fifth, major_seventh]
    }
  end

  def aug_seventh
    @aug_seventh || {
      name: display_chord_name("aug<sup>7</sup>"),
      notes: [self, major_third, augmented_fifth, minor_seventh]
    }
  end

  def half_dim_seventh
    @half_dim_seventh || {
      name: display_chord_name("min<sup>7dim5</sup>"),
      notes: [self, minor_third, diminished_fifth, minor_seventh]
    }
  end

  def dim_seventh
    @dim_seventh || {
      name: display_chord_name("dim<sup>7</sup>"),
      notes: [self, minor_third, diminished_fifth, diminished_seventh]
    }
  end

  def seventh_flat_five
    @seventh_flat_five || {
      name: display_chord_name("7<sup>♭5</sup>"),
      notes: [self, major_third, diminished_fifth, minor_seventh]
    }
  end

  def add_nine
    @add_nine || {
      name: display_chord_name("add9"),
      notes: [self, whole_step, major_third, perfect_fifth]
    }
  end

  def min_add_nine
    @min_add_nine || {
      name: display_chord_name("m<sup>add9</sup>"),
      notes: [self, whole_step, minor_third, perfect_fifth]
    }
  end

  def sus_two
    @sus_two || {
      name: display_chord_name("sus2"),
      notes: [self, whole_step, perfect_fifth]
    }
  end

  def sus_four
    @sus_four || {
      name: display_chord_name("sus4"),
      notes: [self, perfect_fourth, perfect_fifth]
    }
  end

  def display_chord_name(chord_abbreviation)
    "#{display_name}#{chord_abbreviation}".html_safe
  end
end
