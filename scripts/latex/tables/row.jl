include("cell.jl")

@doc raw"""
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
  \hline
  Alice & Bob \\
  \hline
  \hline
  ```
"""
struct Row
  data::Vector{Cell}
  top_rules::Int
  bottom_rules::Int
end

@doc raw"""
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
  \hline
  Alice & Bob \\
  \hline
  \hline
  ```
"""
function Base.show(io::IO, mime::MIME"text/latex", row::Row)
  print(io, "\\hline\n" ^ row.top_rules)
  print(io, join([repr(mime, c) for c in row.data], " & "))
  print(io, "\t\\\\")
  print(io, ("\n" * "\\hline") ^ row.bottom_rules)
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
row(data...; top_rules::Int = 0, bottom_rules::Int = 0) = 
  Row([cell(d) for d in data], top_rules, bottom_rules)