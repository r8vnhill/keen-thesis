include("../option.jl")
include("captions.jl")
include("position.jl")

struct Table
  position::Union{Option{String}, String}
  caption::Union{Option{Caption}, Caption}
end

"""
    _resolve_position(pos::Option{String})::String

Resolves the position from an `Option` type container.

  The `_resolve_position` function checks if an `Option` variable, `pos`, is of type `Some`.
  If so, it extracts the contained value and formats it as a string enclosed in square brackets.
  If `pos` is of type `None`, an empty string is returned.

# Arguments
  - `pos` : The `Option` type variable whose value (if any) is to be extracted and formatted.

# Returns
  - If `pos` is of type `Some`, returns a string of the value enclosed in square brackets.
  - If `pos` is of type `None`, returns an empty string.

# Examples
```julia
julia> _resolve_position(Some("5"))
"[5]"

julia> _resolve_position(None())
""
```
"""
_resolve_position(pos::Option{String})::String = if is_some(pos) "[$(unbox(pos))]" else "" end

"""
    _resolve_position(pos::String)::String

Resolves the position from a string.

# Arguments
  - `pos` : The string whose value is to be checked and potentially formatted.

# Returns
  - If `pos` is not an empty string, returns the string enclosed in square brackets.
  - If `pos` is an empty string, returns an empty string.
"""
_resolve_position(pos::String)::String = if pos != "" "[$pos]" else "" end

function Base.show(io::IO, mime::MIME"text/latex", tab::Table)::Nothing 
  println(io, L"\begin{table}" * @P_str(tab.position))
  if !is_none(tab.caption)
    println(_indent(repr(mime, unbox(tab.caption)), 2))
  else
    ""
  end
  print("\\end{table}")
end

_indent(s::String, n::Int)::String = repeat(" ", n) * s

table(;
  position::Union{String, Option{String}} = None{String}(),
  caption::Union{Caption, Option{Caption}} = None{Caption}()
) = Table(position, caption)


show(stdout, "text/latex", table(position = "ht!", caption = caption("This is a caption.")))
show(stdout, "text/latex", table(position = "ht!", caption = caption("This is a caption.", label = "valid:label_1")))
