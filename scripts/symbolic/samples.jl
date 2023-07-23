include("../commons/utils.jl")
include("../latex/tables/table.jl")

"""
    create_samples()::Vector{Real}

Create and return a predefined set of sample points.

  This function generates a static set of sample points.
  These points may represent a set of independent variables (`x`) for which a function `f` is to be
  evaluated.
  The function logs the sample points and then creates a table that lists each point along with its
  corresponding output value `f(x)`.

  The table is constructed using the `table` and `tabular` syntax from the LaTeX ecosystem 
  (`tabular` package).
  It includes two columns, `x` and `y`, and is typeset with rules separating the rows.
  The table is captioned with the mathematical representation of the function `f` used to generate
  the `y` values.

  The function finally saves the created table as a .tex file for later inclusion in a LaTeX 
  document.
  The path to the saved file is also logged.

# Returns
  - A `Vector{Real}` representing the set of predefined sample points.
"""
function create_samples()::Vector{Real}
  samples = [
    -0.889160069272859
    -0.8561029711395651
    -0.8212951850355155
    -0.8181934125983823
    -0.4298586689110253
    -0.3523275114715019
    -0.0357759083395397
    0.017449673577553337
    0.5290096774879465
    0.8211010511234629
  ]
  @info "Sample points: " samples
  tab = table(
    tabular(
      row(L"x", L"y", top_rules = 1, bottom_rules = 2),
      [row(d, f(d), bottom_rules = 1) for d in samples]...,
      alignment = align"|r|r|"
    ),
    position = p"ht!",
    caption = caption(
      L"A set of points generated from the function 5x^3 - 2x^2 + \sin(x) - 7", 
      label = "tab:bg:gp:repr_ev:points"
    )
  )
  @info "Sample points table:\n$(repr("text/latex", tab))"
  path = savetable(
    tab, 
    "contents/Theoretical_Background/GP/representation/tab-bg-gp-repr_ev-points.tex"
  )
  @info "Sample points table saved to: " path
  return samples
end
