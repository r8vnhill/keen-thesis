"""
    @P_str(s::String)

Parse and validate a LaTeX float position string.

  This macro checks if the given string `s` is a valid LaTeX float position. 
  The valid positions are "h", "t", "b", "p", "!", "H", and can be combined 
  (e.g., "ht!").

  If the position string is valid, it is returned; otherwise, an error is thrown.

# Arguments
  - `s`: A string to parse and validate as a LaTeX float position.

# Returns
  - If `s` is a valid LaTeX float position, `s` is returned. 
  - If `s` is not a valid LaTeX float position, an error is thrown.

# Examples
  ```julia
  julia> @P_str("ht!")
  :("ht!")

  julia> P"ht!"
  :("ht!")

  julia> P"a"
  ERROR: Invalid position string: a
"""
macro P_str(s::String)::String
  if _validate_position(s)
    return "[$s]"
  else
    error("Invalid position string: $s")
  end
end

"""
    _validate_position(str::String)::Bool

Validate the LaTeX float position string.

  This function checks if the given string `str` is a valid LaTeX float position. 

# Arguments
  - `str`: A string to validate as a LaTeX float position.

# Returns
  - `Bool`: `true` if `str` is a valid LaTeX float position, `false` otherwise.
"""
_validate_position(str::String)::Bool = occursin(r"^[htbp!H]+$", str)
