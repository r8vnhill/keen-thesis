include("alignment.jl")

"""
    struct Cell

A struct that represents a cell in a LaTeX table.

  This struct holds data, alignment, and length for a single cell in a LaTeX table. 

# Fields
  - `data::Any`: The contents of the cell.
    This could be a number, a string, or any other type that can be converted to a string.
  - `alignment::Alignment`: The alignment of the cell's contents.
    This is represented by an `Alignment` object.
  - `length::Int`: The length (or width) of the cell.
    If greater than 1, the cell spans multiple columns.

# Examples
  ```julia
  julia> c = Cell("Data", Alignment{:c}(), 2)
  Cell("Data", Alignment{:c}(), 2)

  julia> cell("Data", Alignment{:c}(), 2)
  Cell("Data", Alignment{:c}(), 2)
  ```
"""
struct Cell
  data::Any
  alignment::Alignment
  length::Int
end

"""
    Base.show(io::IO, ::MIME"text/latex", cell::Cell)

Renders a `Cell` object as a LaTeX string.

  This method enables the conversion of a `Cell` object to a LaTeX string when rendered as part of a
  MIME "text/latex" object.

# Arguments
  - `io::IO`: The IO stream to which to write the LaTeX string.
  - `::MIME"text/latex"`: The MIME type to associate with the resulting LaTeX string.
  - `cell::Cell`: The `Cell` object to render as a LaTeX string.

# Returns
  None.
  The function operates by side effect, writing to the provided IO stream.

# Examples
  ```julia
  julia> io = IOBuffer();
  julia> c = Cell("Data", Alignment{:c}(), 2)
  julia> Base.show(io, MIME("text/latex"), c)
  julia> String(take!(io)) # Output: "\\multicolumn{2}{c}{Data}"
  ```
"""
function Base.show(io::IO, ::MIME"text/latex", cell::Cell)
  if cell.length > 1
    print(io, "\\multicolumn{$(cell.length)}{$(cell.alignment)}{$(cell.data)}")
  else
    print(io, "$(cell.data)")
  end
end

"""
    cell(data::Any, alignment::Alignment = align"c", length::Int = 1)::Cell

Create a `Cell` object.

  This function constructs a `Cell` object with the provided `data`, `alignment`, and `length`.

# Arguments
  - `data::Any`: The contents of the cell.
    This could be a number, a string, or any other type that can be converted to a string.
  - `alignment::Alignment = align"c"`: The alignment of the cell's contents.
    By default, it is center-aligned.
  - `length::Int = 1`: The length (or width) of the cell.
    If greater than 1, the cell spans multiple columns. By default, it is 1.

# Returns
  A `Cell` object.

# Exceptions
  Throws an error if `length` is less than 1.

# Examples
  ```julia
  julia> cell("Data", Alignment{:c}(), 2)
  Cell("Data", Alignment{:c}(), 2)
  ```
"""
cell(data::Any; alignment::Alignment = align"c", length::Int = 1)::Cell = 
  if length < 1
    error("Invalid cell length: $length")
  else
    Cell(data, alignment, length)
  end
