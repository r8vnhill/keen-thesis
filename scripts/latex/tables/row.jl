include("cell.jl")

"""
    struct Row

The `Row` struct represents a row in a LaTeX table.

# Fields
  - `data::Vector`: The data in the row.
    It can be a vector or a matrix. 
  - `top_rules::Int`: The number of horizontal lines above the row.
    This corresponds to LaTeX's `\\hline`.
  - `bottom_rules::Int`: The number of horizontal lines below the row.
    This corresponds to LaTeX's `\\hline`.

# Examples
  ```julia
  julia> r = Row(["Alice", "Bob"], top_rules=1, bottom_rules=2)
  Row(["Alice", "Bob"], 1, 2)
  ```
  In LaTeX, this would render as:

  ```
  \\hline
  Alice & Bob \\\\
  \\hline
  \\hline
  ```
"""
struct Row
  data::Vector{Cell}
  top_rules::Int
  bottom_rules::Int
end

"""
    Base.show(io::IO, ::MIME"text/latex", row::Row)

Render a `Row` object to a LaTeX table row.

# Arguments
  - `io::IO`: An `IO` stream to which the LaTeX code is written.
  - `row::Row`: A `Row` object containing the data and formatting for the table row.

# Output
  - The LaTeX code for the table row is written to the `IO` stream.
    Each data item in the row is separated by " & ", the LaTeX column separator.
    The number of horizontal rules above and below the row is specified by `row.top_rules` and
    `row.bottom_rules`, respectively.

# Examples
  ```julia
  julia> r = Row(["Alice", "Bob"], top_rules=1, bottom_rules=2)
  Row(["Alice", "Bob"], 1, 2)

  julia> show(stdout, MIME("text/latex"), r)
  \\hline
  Alice & Bob \\\\
  \\hline
  \\hline
  ```
"""
function Base.show(io::IO, ::MIME"text/latex", row::Row)
  print(io, "\\hline\n" ^ row.top_rules)
  print(io, join(_format_data(row.data), " & "))
  print(io, "\t\\\\")
  print(io, ("\n" * "\\hline") ^ row.bottom_rules)
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
function _format_data(data::Vector)::Vector{String}
  return [if d isa Number
    format_number(d)
  else
    d
  end for d in data]
end

"""
    row(data::Vector; top_rules::Int = 0, bottom_rules::Int = 0)

Create a `Row` object representing a row in a LaTeX table.

# Arguments
  - `data::Vector`: A vector or a matrix representing the row's data.
  - `top_rules::Int=0`: Optional. The number of horizontal rules above the row. Default is `0`.
  - `bottom_rules::Int=0`: Optional. The number of horizontal rules below the row. Default is `0`.

# Returns
  - `Row`: A `Row` object containing the data and the number of horizontal rules for the LaTeX table 
    row.

# Examples
  ```julia
  julia> r = row(["Alice", "Bob"], top_rules=1, bottom_rules=2)
  Row(["Alice", "Bob"], 1, 2)
  ```
"""
row(data::Vector; top_rules::Int = 0, bottom_rules::Int = 0) = Row(data, top_rules, bottom_rules)