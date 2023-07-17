"""
    Alignment{T}

Wrapper struct for LaTeX table column alignments.

  This struct serves as a wrapper for LaTeX table column alignments, 
  where `T` is a `Symbol` representing the column alignment string.

# Fields
  - `T`: A `Symbol` representing the LaTeX column alignment string.

# Examples
  ```julia
  julia> Alignment{:c}()
  Alignment{:c}()

  julia> Alignment{:l}()
  Alignment{:l}()

  julia> Alignment{:r}()
  Alignment{:r}()
  ```
"""
struct Alignment{T} end

"""
    Base.show(io::IO, ::MIME"text/latex", a::Alignment{T}) where {T}

Renders an `Alignment` object as a LaTeX string.

This method enables the conversion of an `Alignment` object to a LaTeX string when rendered as 
part of a MIME "text/latex" object.

# Arguments
- `io::IO`: The IO stream to which to write the LaTeX string.
- `::MIME"text/latex"`: The MIME type to associate with the resulting LaTeX string.
- `a::Alignment{T}`: The `Alignment` object to render as a LaTeX string.

# Returns
None. The function operates by side effect, writing to the provided IO stream.

# Examples
```julia
julia> io = IOBuffer();
julia> a = Alignment{:c|l|r}()
julia> Base.show(io, MIME("text/latex"), a)
julia> String(take!(io)) # Output: "c|l|r"
```
"""
Base.show(io::IO, ::MIME"text/latex", a::Alignment{T}) where {T} = print(io, T)

"""
@align_str(s::String)

Parse and validate a LaTeX table column alignment string.

  This macro checks if the given string `s` is a valid LaTeX table column alignment.
  The valid alignments are:
  - "c" for center,
  - "l" for left,
  - "r" for right.

  The string can also contain spaces and the "|" character to separate and denote the boundary of
  the columns respectively.

  If the alignment string is valid, a `Alignment` object is returned with the string `s` as a
  `Symbol` type parameter.
  If not, an error is thrown.

# Arguments
  - `s`: A string to parse and validate as a LaTeX table column alignment.

# Returns
  - If `s` is a valid LaTeX table column alignment, an `Alignment` object is returned with the
    string `s` as a `Symbol` type parameter.
  - If `s` is not a valid LaTeX table column alignment, an error is thrown.

# Examples
  ```julia
  julia> @align_str("c")
  Alignment{:c}()

  julia> @align_str("c|l|r")
  Alignment{:c|l|r}()

  julia> @align_str("a b")
  ERROR: Invalid alignment string: a b
  ```
"""
macro align_str(s::String)
  if _validate_alignment(s)
    return :(Alignment{$(Expr(:quote, Symbol(s)))}())
  else
    error("Invalid alignment string: $s")
  end
end

"""
    _validate_alignment(s::String)::Bool

Validate a table column alignment string.

  This function checks if the given string `s` is a valid alignment for table columns in LaTeX.
  The valid alignments are:
  - "c" for center,
  - "l" for left,
  - "r" for right.

  The string can also contain spaces and the "|" character to separate and denote the boundary of
  the columns respectively.

# Arguments
  - `s`: A string to validate as a table column alignment.

# Returns
  - `Bool`: `true` if `s` is a valid table column alignment, `false` otherwise.

# Examples
  ```julia
  julia> _validate_alignment("c")
  true

  julia> _validate_alignment("c|l|r")
  true

  julia> _validate_alignment("c c")
  true

  julia> _validate_alignment("| r | c l")
  true

  julia> _validate_alignment("a b")
  false
  ```
"""
function _validate_alignment(s::String)::Bool 
  valid_chars = ['c', 'l', 'r']
  align_chars = filter(c -> !(c in [' ', '|']), collect(strip(s)))
  return all(c -> c in valid_chars, align_chars)
end
