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

"""
    format_number(num::Real)

Format a number by adding `\\,` for every thousand in the integer part and after every 3 decimal 
  places.

  This function takes a number as input, splits it into integer and decimal parts, and then 
  formats each part separately.
  It inserts `\\,` after every group of three digits in the integer part (counting from the right),
  and after every three decimal places.

# Arguments
  - `num::Real`: The number to format.

# Returns
  - A string representing the formatted number.

# Examples
  ```julia
  julia> format_number(1000)
  "1\\,000.000\\,000"

  julia> format_number(124378.6927)
  "124\\,378.692\\,700"

  julia> format_number(200.123456789)
  "200.123\\,456\\,789"
  ```
"""
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