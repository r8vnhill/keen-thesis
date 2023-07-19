using LaTeXStrings
using Logging
include("../../commons/utils.jl")
include("../../commons/option.jl")
include("../captions.jl")
include("../position.jl")
include("tabular.jl")

"""
    struct Table

A type representing a LaTeX table.

  The `Table` type provides a representation of a LaTeX table, including its content, position, and
  caption.
  The content of the table is represented by a `Tabular` object, while the position and caption are
  optionally represented by `Position` and `Caption` objects, respectively.

# Fields
  - `content::Tabular`: A `Tabular` object representing the content of the table.
  - `position::Union{Option{Position}, Position}`: An optional `Position` object representing the
    position of the table.
    If the position is not specified, it defaults to `None`.
  - `caption::Union{Option{Caption}, Caption}`: An optional `Caption` object representing the
    caption of the table.
    If the caption is not specified, it defaults to `None`.

# Examples
  ```julia
  julia> t = Table(
    tabular(["Alice" "Bob"; 30 25], alignment="ll"), 
    position=p"h",
    caption=caption("This is a table", label="tab:example")
  )
  Table(
    Tabular(["Alice" "Bob"; 30 25], "ll"),
    Some(Position("h")),
    Some(Caption("This is a table", "tab:example"))
  )
  ```
"""
struct Table
  content::Tabular
  position::Union{Option{Position}, Position}
  caption::Union{Option{Caption}, Caption}
end

@doc raw"""
    Base.show(io::IO, mime::MIME"text/latex", tab::Table)

Render a `Table` object to a LaTeX `table` environment.

  This function outputs the LaTeX code for a `table` environment with the content, position, and 
  caption specifications of the given `Table` object `tab`.
  The LaTeX code is written to the provided `IO` stream.

# Arguments
  - `io::IO`: The `IO` stream to which the LaTeX code is written.
  - `mime::MIME"text/latex"`: Specifies the format of the output, which is LaTeX in this case.
  - `tab::Table`: A `Table` object containing the content, position, and caption for the table.

# Output
  - The LaTeX `table` environment is written to the `IO` stream.

# Examples
  ```julia
  julia> content = tabular([["Name", "Age"],["Alice", 30],["Bob", 25]]);
  julia> position = Position("ht");
  julia> caption = caption("Table caption", label="tab:label");
  julia> table = Table(content, position, caption);
  julia> show(stdout, MIME("text/latex"), table)
  \begin{table}[ht]
    \centering
      \begin{tabular}{cc}
      Name & Age \\
      \hline
      Alice & 30 \\
      Bob & 25 \\
      \end{tabular}
    \caption{Table caption}
    \label{tab:label}
  \end{table}
  ```
"""
function Base.show(io::IO, mime::MIME"text/latex", tab::Table)::Nothing 
  println(io, raw"\begin{table}" * if !is_none(tab.position) repr(tab.position) else "" end)
  println(io, indent(raw"\centering", 2))
  println(io, indent(repr(mime, tab.content), 2))
  if !is_none(tab.caption)
    println(io, indent(repr(mime, unbox(tab.caption)), 2))
  else
    print(io, "")
  end
  print(io, "\\end{table}")
end

"""
    table(
      content::Tabular; 
      position::Union{Position, Option{Position}} = None{Position}(), 
      caption::Union{Caption, Option{Caption}} = None{Caption}()
    )::Table

Construct a `Table` object with the specified content, position, and caption.

# Arguments
  - `content::Tabular`: The table content as a `Tabular` object.
  - `position::Union{Position, Option{Position}}`: The table position as a `Position` object or
    `None`.
    This is optional and defaults to `None`.
  - `caption::Union{Caption, Option{Caption}}`: The table caption as a `Caption` object or `None`.
    This is optional and defaults to `None`.

# Returns
  - A `Table` object with the specified content, position, and caption.

# Examples
  ```julia
  julia> content = tabular([["Name", "Age"],["Alice", 30],["Bob", 25]])
  julia> position = Position("ht")
  julia> caption = caption("Table caption", label="tab:label")
  julia> table = table(content, position=position, caption=caption)
  Table(
    Tabular(["Name" "Age"; "Alice" 30; "Bob" 25], "cc"),
    Some(Position("ht")),
    Some(Caption("Table caption", "tab:label"))
  )
  ```
"""
table(
  content::Tabular;
  position::Union{Position, Option{Position}} = None{Position}(),
  caption::Union{Caption, Option{Caption}} = None{Caption}()
) = Table(content, position, caption)

"""
    savetable(tab::Table; filepath::String, overwrite::Bool = true)::String
    savetable(tab::Table; io::IO = stdout, overwrite::Bool = true)::Nothing

Save the LaTeX representation of a `Table` object to a file or an IO stream.

  These functions generate the LaTeX code for the `Table` object `tab` and writes it to a file or IO stream. 

# Arguments
  - `tab`: The `Table` object to save.

# Keyword Arguments
  - `dir`: The directory in which to save the file. Defaults to the current directory ".".
  - `filepath`: The full path to the file, including the filename.
  - `io`: An IO stream to write to. Overrides `filename`, `dir`, and `filepath`.
  - `overwrite`: If true (default), overwrite the file if it exists. If false, throw an error if the file exists.

# Exceptions
  - Throws an error if `overwrite` is false and the file already exists.

# Returns
  - When using `filepath` parameter, the function returns the filepath to the saved file.
  - When using the `io` parameter, the function returns `Nothing`.

# Examples
  ```julia
  julia> content = tabular([["Name", "Age"],["Alice", 30],["Bob", 25]])
  julia> position = Position("ht")
  julia> caption = caption("Table caption", label="tab:label")
  julia> table = table(content, position=position, caption=caption)
  julia> savetable(table, filepath="table.tex")
  "table.tex"
  julia> savetable(table, io=open("table.tex", "w"))
  ```
"""
function savetable(
  tab::Table,
  filepath::String;
  overwrite::Bool = true
)::String
  savetable(tab, io = open(filepath, "w"), overwrite = overwrite)
  filepath
end

function savetable(
  tab::Table;
  io::IO = stdout,
  overwrite::Bool = true
)::Nothing 
  @debug "Saving table to" repr(io)
  if !overwrite && isfile(io)
    error("File already exists: $(repr(io))")
  end
  show(io, "text/latex", tab)
  if io isa IOStream
    close(io)
  end
end
