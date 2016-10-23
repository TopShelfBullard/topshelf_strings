module NotesHelper
  def print_fretboard(fretboard)
    frets = ["0    #{print_fret(fretboard[:frets].shift)}\n     ============="]
    fret_number = 1
    fretboard[:frets].each do |fret|
      if fret_number < 10
        frets << "#{fret_number}    #{print_fret(fret)}\n     _____________"
      else
        frets << "#{fret_number}   #{print_fret(fret)}\n    _____________"
      end
      fret_number = fret_number + 1
    end
    frets.join("\n")
  end

  def print_fret(fret)
    fourth, third, second, first = fret
    "#{regularize_whitespace(fourth)}#{regularize_whitespace(third)}#{regularize_whitespace(second)}#{regularize_whitespace(first)}"
  end

  def regularize_whitespace(string)
    return " | " unless string
    unused_space = 3 - string.length
    return string unless unused_space > 0
    if unused_space == 1
      return " #{string}"
    end
    if unused_space == 2
      return " #{string} "
    end
  end
end
