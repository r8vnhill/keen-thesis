include("../../commons/utils.jl")
include("alignment.jl")
include("row.jl")

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
  alignment::Alignment
end

@doc raw"""
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
  \begin{tabular}{ll}
    Name & Age \\
    \hline
    Alice & 30 \\
    Bob & 25 \\
  \end{tabular}
  ```
"""
function Base.show(io::IO, mime::MIME"text/latex", tab::Tabular)
  println(io, "\\begin{tabular}{$(repr(mime, tab.alignment))}")
  for r in tab.content
    println(io, indent(repr(mime, r), 2))
  end
  print(io, "\\end{tabular}")
end

function get(tab::Tabular, i::Int)::Row
  return tab.content[i]
end

"""
    tabular(content::Matrix; alignment::Alignment

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
  alignment::Alignment
) = Tabular(content, alignment)
