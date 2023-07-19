using LaTeXStrings
using Logging
using Plots; pythonplot()
using Statistics
include("../commons/draw.jl")
include("../commons/mse.jl")
include("../commons/population.jl")
include("../latex/tables/alignment.jl")
include("../latex/tables/table.jl")
include("../latex/text.jl")
include("individuals.jl")
include("selection.jl")

println("""

===========================================
=== Starting symbolic regression script ===
===========================================

"""
)

""" Sample points. """
data = [
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
println("Sample points: ")
println(repr("text/plain", data))

rows = vcat(
  row([L"x", L"y"], top_rules = 1, bottom_rules = 2),
  [row([d, f(d)], bottom_rules = 1) for d in data]
)

savetable(
  table(
    tabular(rows, alignment = align"|r|r|"),
    position = p"ht!",
    caption = caption(
      "A set of points generated from the function " * L"5x^3 - 2x^2 + \sin(x) - 7", 
      label = "tab:bg:gp:repr_ev:points"
    )
  ), "contents/Theoretical_Background/GP/representation/tab-bg-gp-repr_ev-points.tex"
)

draw_lines(
  cat(f, initial_individuals, dims=1), 
  x_lim = -5 => 5,
  names = vcat([L"f(x)"], [L"\mathrm{I}_%$i(x)" for i in eachindex(initial_individuals)]),
  line_styles = [2 => :solid, 1 => :solid, 2 => :dot, 2 => :dashdot, 2 => :dash],
  title = "Individuals of the population after initialization",
  x_label = L"x",
  y_label = L"f(x)",
  filename = "img/theoretical_framework/gp_pop_init.png"
)

initial_population = Population(
  [Individual{Function}(
      initial_individuals[i], 
      L"\mathrm{I}_%$i(x)", 
      mse(f.(data), initial_individuals[i].(data))
    ) for i in eachindex(initial_individuals)]
)

println("Initial population: ", repr("text/plain", initial_population))
println("Initial population average fitness: ", average_fitness(initial_population))
println("Initial population standard deviation of fitness: ", stddev_fitness(initial_population), 
  "\n")

savetable(
  table(
    tabular(
      vcat(
        row(cell(bold"Generation 0", alignment = align"c", length = 4), bottom_rules = 2),
        row([bold"Individual", bold"Program", bold"Height", bold"Fitness"], bottom_rules = 1),
        row([L"\mathbf{I}_%$i", initial_population.individuals[i].name, 
          initial_population.individuals[i].height, initial_population.individuals[i].ϕ
        ]) for i in eachindex(initial_population.individuals)
      ), alignment = align"c|c|c|r"
    )
  )
)
save_population(initial_population, "data/bg_gp_sym_pop_init.txt")

sum_of_fitnesses = sum(Φ(initial_population))

corrected_population = map(
  individual -> Individual{Function}(
    individual.value, 
    individual.name, 
    sum_of_fitnesses - individual.ϕ
  ), 
  initial_population
)

println("Corrected population: ", corrected_population)

P = selection_probabilities(corrected_population)
println("Selection probabilities: ", P, "\n")

# Save the probabilities to a file.
open("data/gp_sym_probabilities_1.txt", "w") do io
  println(io, "Individual  & Fitness & Selection Probability \\\\")
  println(io, "\\hline")
  for (ind, prob) in zip(corrected_population.individuals, P)
    println(io, ind.name, " & ", ind.ϕ, " & ", prob * 100, "\\% \\\\")
  end
  println(io, "\\hline")
end

survivors = [
  initial_population.individuals[2]
  initial_population.individuals[3]
]

draw_lines(
  cat(f, map(i -> i.value, survivors); dims = 1),
  x_lim = -1 => 1,
  names = ["\$f(x)\$", map(i -> i.name, survivors)...],
  line_styles = [2 => :solid, 2 => :dot, 2 => :dashdot],
  title = "Survivors of the population and the target function",
  x_label = "\$x\$",
  y_label = "\$f(x)\$",
  filename = "img/theoretical_framework/gp_pop_sel_survivors.png"
)

""" Output 1: x^2 - (5 + sin(x))  """
O_1(x) = x^2 - (5 + sin(x))

""" Output 2: 5 * 5 """
O_2(_) = 5 * 7

println("Plotting the population and the target function...")
plot(
  f, -1, 1, 
  label=L"$f(x)$", 
  lw=2, 
  tickfontsize=12, 
  legendfontsize=12, 
  guidefontsize=14
)
plot!(survivors[1].value, label=L"$\mathrm{I}_2(x)$", lw=2, ls=:dashdot)
plot!(survivors[2].value, label=L"$\mathrm{I}_3(x)$", lw=2, ls=:dash)
plot!(O_1, label=L"$\mathrm{O}_1(x)$", lw=1)
plot!(O_2, label=L"$\mathrm{O}_2(x)$", lw=2, ls=:dot)
title!("Individuals of the population and the target function (after crossover)")
xlabel!(L"$x$")
ylabel!(L"$f(x)$")
display(plot!())
png("img/theoretical_framework/gp_pop_crossover.png")  # Save the plot to a file.

"""
Mean squared errors.
"""
mses = [
  mse(f.(data), survivors[1].value.(data))
  mse(f.(data), survivors[2].value.(data))
  mse(f.(data), O_1.(data))
  mse(f.(data), O_2.(data))
]
println("Mean squared errors: ", mses)

# Save the mean squared errors to a file.
open("data/bg_gp_sym_mse_crossover.txt", "w") do io
  println(io, "mse(f(x), initial_population[2](x)) = ", mses[1])
  println(io, "mse(f(x), initial_population[3](x)) = ", mses[2])
  println(io, "mse(f(x), O_1(x)) = ", mses[3])
  println(io, "mse(f(x), O_2(x)) = ", mses[4])
  println(io, "average = ", mean(mses))
  println(io, "std = ", std(mses))
end

mean_mse_X = mean(mses)
std_mse_X = std(mses)

avg_improvement = (mean_mse_Σ - mean_mse_X) / mean_mse_Σ * 100
println("Improvement: ", avg_improvement, "%")

std_improvement = (std_mse_Σ - std_mse_X) / std_mse_Σ * 100
println("Standard deviation improvement: ", std_improvement, "%")

mutated_mses = [
  mse(f.(data), mutated_population[1].(data))
  mse(f.(data), mutated_population[2].(data))
  mse(f.(data), mutated_population[3].(data))
  mse(f.(data), mutated_population[4].(data))
]

println("Mutated mean squared errors: ", mutated_mses)

mutated_avg_mses = mean(mutated_mses)
mutated_std_mses = std(mutated_mses)

println("Mutated average: ", mutated_avg_mses)
println("Mutated standard deviation: ", mutated_std_mses)

mutated_avg_improvement = (mean_mse_X - mutated_avg_mses) / mean_mse_X * 100
println("Mutated improvement: ", mutated_avg_improvement, "%")

mutated_std_improvement = (std_mse_X - mutated_std_mses) / std_mse_X * 100
println("Mutated standard deviation improvement: ", mutated_std_improvement, "%")
