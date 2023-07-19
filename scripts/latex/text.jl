@doc raw"""
    @bold_str(s::String)

Format a string in bold in LaTeX.

# Arguments
- `s::String`: The string to format.

# Returns
- A string representing the input string formatted in bold.

# Examples
```julia
julia> bold"hello"
"\textbf{hello}"
```
"""
macro bold_str(s::String)
  return "\textbf{$s}"
end

@doc raw"""
    @bold(s::String)

A convenient macro to format a string in bold in LaTeX.

This macro is identical to `@bold_str`.

# Examples
```julia
julia> @bold("hello")
"\textbf{hello}"
```
"""
macro bold(s::String)
  return @macroexpand@bold_str(s)
end

@doc raw"""
    @italic_str(s::String)

Format a string in italic in LaTeX.

# Arguments
- `s::String`: The string to format.

# Returns
- A string representing the input string formatted in italic.

# Examples
```julia
julia> italic"hello"
"\textit{hello}"
```
"""
macro italic_str(s::String)
  return "\textit{$s}"
end

@doc raw"""
    @italic(s::String)

A convenient macro to format a string in italic in LaTeX.

  This macro is identical to `@italic_str`.

# Examples
  ```julia
  julia> @italic("hello")
  "\textit{hello}"
  ```
"""
macro italic(s::String)
  return @macroexpand@italic_str(s)
end

@doc raw"""
    @emph_str(s::String)

Format a string in emph in LaTeX.

# Arguments
- `s::String`: The string to format.

# Returns
- A string representing the input string formatted in emph.

# Examples
```julia
julia> emph"hello"
"\emph{hello}"
```
"""
macro emph_str(s::String)
  return "\emph{$s}"
end

@doc raw"""
    @emph(s::String)

A convenient macro to format a string in emph in LaTeX.
  
    This macro is identical to `@emph_str`.

# Examples
```julia
julia> @emph("hello")
"\emph{hello}"
```
"""
macro emph(s::String)
  return @macroexpand@emph_str(s)
end
