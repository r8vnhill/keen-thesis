using Printf

"""
    indent(s::String, n::Int)::String

Indent a multiline string by `n` spaces.

# Arguments
  - `s::String`: The string to indent.
  - `n::Int`: The number of spaces to use for the indentation.

# Returns
  - `String`: The indented string.
    Each line in the string is indented by `n` spaces.

# Examples
  ```julia
  julia> s = "This is a\\nmulti-line string"
  "This is a\\nmulti-line string"

  julia> indent(s, 4)
  "    This is a\\n    multi-line string"
  ```
"""
indent(s::String, n::Int)::String = join([" "^n * line for line in split(s, '\n')], '\n')

function format_number(num::Real)
  # split the number into integer and decimal parts
  int, frac = split(@sprintf("%.6f", num), ".")
  # format the integer part
  int = reverse(join([reverse(int[i:min(end, i + 2)]) for i in 1:3:length(int)], "\\,"))
  # format the decimal part
  frac = join([frac[i:min(end, i + 2)] for i in 1:3:length(frac)], "\\,")
  # join the integer and decimal parts
  return int * "." * frac
end