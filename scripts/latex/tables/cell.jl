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
  @assert cell.length > 0
  data = _format_data(cell.data)
  if cell.length > 1
    print(io, "\\multicolumn{$(cell.length)}{$(repr("text/latex", cell.alignment))}{$data}")
  else
    print(io, data)
  end
end

"""
    _format_data(data::Vector)::Vector{String}

Format the data in a vector for display in a LaTeX table.

  This function takes a vector of data, `data`, and formats it for display in a LaTeX table. 
  Specifically, it converts numerical data to a LaTeX-friendly string format using the
  `format_number` function.
  Non-numerical data are left unchanged.

# Arguments
  - `data::Vector`: A vector of data to format for display in a LaTeX table.

# Returns
  A vector of formatted strings, ready to be displayed in a LaTeX table.

# Examples
  ```julia
  julia> _format_data([1000, 124378.6927, 200.123456789])
  3-element Vector{String}:
  "1\\,000"
  "124\\,378.692\\,7"
  "200.123\\,456\\,789"
  ```
"""
_format_data(c::Any)::String = if c isa Cell
  _format_data(c.data)
elseif c isa Number
  format_number(c)
else
  c
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
  elseif data isa Cell
    data
  else
    Cell(data, alignment, length)
  end
