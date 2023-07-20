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

@doc raw"""
    format_number(num::Real)

Format a number by adding `\,` for every thousand in the integer part and after every 3 decimal 
  places.

  This function takes a number as input, splits it into integer and decimal parts, and then 
  formats each part separately.
  It inserts `\,` after every group of three digits in the integer part (counting from the right),
  and after every three decimal places.

# Arguments
  - `num::Real`: The number to format.

# Returns
  - A string representing the formatted number.

# Examples
  ```julia
  julia> format_number(1000)
  "1\,000.000\,000"

  julia> format_number(124378.6927)
  "124\,378.692\,700"

  julia> format_number(200.123456789)
  "200.123\,456\,789"
  ```
"""
function format_number(num::Real)
  # check if the number is an integer
  if num isa Integer
    return replace(_format_int(num), "," => "\\,")
  else
    # round the number to the seventh decimal
    num = round(num, digits=7)
    # split the number into integer and decimal parts
    int, frac = split(@sprintf("%.6f", num), ".")
    # format the integer part
    int = _format_int(parse(Int, int))
    # format the decimal part
    frac = join([frac[3*i+1:min(end, 3*i+3)] for i in 0:div(length(frac), 3)-1], ",")
    # join the integer and decimal parts
    return replace(int * "." * frac, "," => "\\,")
  end
end

function _format_int(num::Integer)::String
  reversed = num |> string |> reverse
  # Insert a comma after every 3 digits
  result = ""
  for (i, c) in enumerate(reversed)
    if i % 3 == 1 && i != 1
      result *= ","
    end
    result *= string(c)
  end
  reverse(result)
end
