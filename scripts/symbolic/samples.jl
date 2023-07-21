include("../commons/utils.jl")
include("../latex/tables/table.jl")

# TODO: Learn how to change the default log level uwu [R8V]
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

  rows = vcat(
    row([L"x", L"y"], top_rules = 1, bottom_rules = 2),
    [row([d, f(d)], bottom_rules = 1) for d in samples]
  )
  @info "Sample points table: " rows

  tab = table(
    tabular(rows, alignment = align"|r|r|"),
    position = p"ht!",
    caption = caption(
      "A set of points generated from the function " * L"5x^3 - 2x^2 + \sin(x) - 7", 
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