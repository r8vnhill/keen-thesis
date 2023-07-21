using Printf

macro plain_info(msgs...)
  quote
    @info map(x -> x isa String ? x : repr("text/plain", x), $(esc.(msgs))...)...
  end
end

"""
    indent(s::1String, n::Int)::String

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
  
Format a real number for display, grouping digits for readability.

  For an integer input, this function groups digits into sets of three, separated by `\,`,
  starting from the rightmost digit.

  For a non-integer input, the function first rounds the number to the seventh decimal place, then
  separates the integer and fractional parts.
  The integer part is formatted in the same way as for an integer input.
  The fractional part is also grouped into sets of three digits, separated by `\,`.

# Arguments
  - `num`: The number to format.

# Returns
  - A string representing the formatted number.

# Example
  ```julia
  julia> format_number(123456.789123456)
  "123\,456.789\,123"
  ```
"""
format_number(num::Real)::String = if num isa Integer # check if the number is an integer
  replace(_format_int(num), "," => "\\,")
else
  num = round(num, digits=7)
  int, frac = split(@sprintf("%.6f", num), ".")
  int = _format_int(parse(Int, int))
  frac = join([frac[3 * i + 1:min(end, 3 * i + 3)] for i in 0:div(length(frac), 3) - 1], ",")
  replace(int * "." * frac, "," => "\\,")
end
  
  
  """
      _format_int(num::Integer)::String
  
  Format an integer for display, grouping digits for readability.
  
  This function groups digits into sets of three, separated by commas,
  starting from the rightmost digit.
  
  # Arguments
  - `num`: The number to format.
  
  # Returns
  - A string representing the formatted number.
  
  # Example
  ```julia
  julia> _format_int(123456)
  "123,456"
  ```
  """
  function _format_int(num::Integer)::String
    # implementation omitted for brevity
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
