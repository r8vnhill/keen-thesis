"""
    struct Position{p}

A type representing the LaTeX float position.

  The `Position` is a parametric struct where the type parameter `p` represents the LaTeX float 
  position as a Symbol.

  The float positions in LaTeX can be any combination of "h" (approximate location), "t" (top of the
  page), "b" (bottom of the page), "p" (separate page), "!" (override internal parameters for good
  float positions), and "H" (exactly here - requires the float package).

# Fields
  - `p`: A symbol representing the float position.
"""
struct Position{P} end

"""
    Base.show(io::IO, ::Position{P}) where {P}

Display the value of a `Position` object.

  This method is an overload of the `Base.show` function.
  It displays the LaTeX float position represented by a `Position` object.
  The displayed value is formatted as `[P]`, where `P` is replaced with the actual position.

# Arguments
  - `io`: An I/O stream to which the output is printed.
  - `::Position{P}`: The `Position` object to be displayed.
    The `P` represents the float position as a symbol.

# Example
  ```julia
  julia> P = Position{:h}()
  julia> println(P)
  [h]
  ```
"""
Base.show(io::IO, ::Position{P}) where {P} = print(io, "[$P]")

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
macro p_str(s::String)
  if _validate_position(s)
    :(Position{$(Expr(:quote, Symbol(s)))}())
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
