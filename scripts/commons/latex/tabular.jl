include("../utils.jl")

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
  data::Vector
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

function _format_data(data::Vector)::Vector{String}
  return [if d isa Number
    format_number(d)
  else
    d
  end for d in data]
end

"""
    row(data::Vector; top_rules::Int = 0, bottom_rules::Int = 0)
    row(data...; kwargs...)

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

"""
    struct Tabular

A structure for representing a LaTeX tabular environment.

  This structure is used to store the content of a LaTeX tabular environment along with the column 
  alignment specifications.

# Fields
  - `content`: A matrix of any type, representing the contents of the tabular.
    Each cell in the matrix corresponds to a cell in the tabular.
  - `alignment`: A string representing the alignment of the columns.
    The alignment string must contain the same number of alignment specifiers (e.g., "c", "l", "r")
    as there are columns in the content.

# Example
  ```julia
  julia> Tabular([["Name", "Age"], ["John", 32], ["Jane", 28]], "lc")
  Tabular([["Name", "Age"], ["John", 32], ["Jane", 28]], "lc")
  ```
"""	
struct Tabular
  content::Vector{Row}
  alignment::String
end

"""
    Base.show(io::IO, ::MIME"text/latex", tab::Tabular)

Render a `Tabular` object to a LaTeX `tabular` environment.

  This function prints the LaTeX code for a `tabular` environment with the content and alignment
  specifications of the given `Tabular` object `tab`.

# Arguments
  - `io`: An `IO` stream to which the LaTeX code is written.
  - `tab`: A `Tabular` object containing the content and alignment for the tabular.

# Exceptions
  - Throws an `ArgumentError` if the number of alignment specifiers does not match 
    the number of columns in `tab.content`.

# Output
  - The LaTeX `tabular` environment is written to the `IO` stream.

# Examples
  ```julia
  julia> t = Tabular([
      "Name" "Age"
      "Alice" 30
      "Bob" 25],
    "ll"
  )
  julia> show(stdout, MIME("text/latex"), t)
  \\begin{tabular}{ll}
  Name & Age \\\\
  \\hline
  Alice & 30 \\\\
  Bob & 25 \\\\
  \\end{tabular}
  ```
"""
function Base.show(io::IO, mime::MIME"text/latex", tab::Tabular)
  println(io, "\\begin{tabular}{$(tab.alignment)}")
  for r in tab.content
    println(io, indent(repr(mime, r), 2))
  end
  print(io, "\\end{tabular}")
end

"""
    tabular(content::Matrix; alignment::String = repeat("c", size(content, 2))) -> Tabular

Construct a `Tabular` object with the specified content and alignment.

  The function creates a `Tabular` object that represents a LaTeX tabular environment.
  It takes as input a matrix that specifies the content of the table and an optional string that
  specifies the alignment of each column.
  If no alignment is specified, the default is center alignment for all columns.

# Arguments
  - `content`: A matrix specifying the content of the table.
    Each entry corresponds to a cell in the table.
  - `alignment`: An optional string specifying the alignment of each column.
    The string should contain one character for each column, where "c" indicates center alignment, 
    "l" indicates left alignment, and "r" indicates right alignment.
    If no alignment is specified, the default is center alignment for all columns.

# Returns
  - A `Tabular` object that represents the specified LaTeX tabular environment.

# Examples
  ```julia
  julia> t = tabular(["Alice" "Bob"; 30 25], alignment="ll")
  Tabular(["Alice" "Bob"; 30 25], "ll")
  ```
"""
tabular(
  content::Vector{Row};
  alignment::String
) = Tabular(content, alignment)
