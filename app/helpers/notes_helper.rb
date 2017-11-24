module NotesHelper
  def format_chord_group_title(title)
    title.split("_").join(" ")
  end

  def note_name_or_space(note_name)
    note_name || "&nbsp;".html_safe
  end

  def accidental_class(note_name)
    return "" if note_name.blank? || note_name.length < 2
    return "with_accidental" if note_name.length == 2
    return "with_double_accidental" if note_name.length == 3
  end

  def fret_class(fret_index)
    return "fret_open" if fret_index == 0
    return "fret_top" if fret_index == 1
    return "fret_single_dot" if [3, 5, 7, 10, 15].include?(fret_index)
    return "fret_double_dot" if fret_index == 12
    return "fret_norm"
  end

  def fingered_or_empty_fret_class(note_name)
    note_name.nil? ? "empty" : "fingered"
  end
end
