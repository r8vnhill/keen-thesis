using LaTeXStrings
using Logging
using Plots; pythonplot()
using Statistics
include("../commons/draw.jl")
include("../commons/mse.jl")
include("../commons/population.jl")
include("../commons/utils.jl")
include("../latex/tables/alignment.jl")
include("../latex/tables/table.jl")
include("../latex/text.jl")
include("individuals.jl")
include("selection.jl")
include("samples.jl")

println("""

===========================================
=== Starting symbolic regression script ===
===========================================

""")

samples = create_samples()

initial_population = create_population()

sum_of_fitnesses = sum(Φ(initial_population))

corrected_population = map(
  individual -> Individual{Function}(
    individual.value, 
    individual.name, 
    sum_of_fitnesses - individual.ϕ
  ),
  initial_population
)

println("Corrected population: $(repr("text/plain", corrected_population))")

P = selection_probabilities(corrected_population)
println("Selection probabilities: $(repr("text/plain", P))\n")

savetable(
  table(
    tabular(
      row(
        [bold"Individual", bold"Fitness", bold"Selection Probability"],
        bottom_rules = 1,
        top_rules = 1
      ),
      [row(
        corrected_population.individuals[i].name,
        corrected_population.individuals[i].ϕ,
        format_number(P[i] * 100) * "\\%", 
        bottom_rules = 1) 
      for i in eachindex(corrected_population.individuals)]...,
      alignment = align"|l|r|r|"
    ), caption = caption(
      "Selection probabilities for the symbolic regression problem.", 
      label = "tab:bg:gp:sel:prob"
    ), position = p"ht!"
  ), raw"contents\Theoretical_Background\GP\selection\tab-bg-gp-sel-prob.tex"
)

mean_mse_initial = mean([
  mse(f.(samples), initial_population.individuals[i].value.(samples)) for i in eachindex(initial_population.individuals)
])

std_mse_initial = std([
  mse(f.(samples), initial_population.individuals[i].value.(samples)) for i in eachindex(initial_population.individuals)
])

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
  mse(f.(samples), survivors[1].value.(samples))
  mse(f.(samples), survivors[2].value.(samples))
  mse(f.(samples), O_1.(samples))
  mse(f.(samples), O_2.(samples))
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

avg_improvement = (mean_mse_initial - mean_mse_X) / mean_mse_initial * 100
println("Improvement: ", avg_improvement, "%")

std_improvement = (std_mse_initial - std_mse_X) / std_mse_initial * 100
println("Standard deviation improvement: ", std_improvement, "%")

mutated_mses = [
  mse(f.(samples), mutated_population[1].(samples))
  mse(f.(samples), mutated_population[2].(samples))
  mse(f.(samples), mutated_population[3].(samples))
  mse(f.(samples), mutated_population[4].(samples))
]

println("Mutated mean squared errors: ", mutated_mses)

mutated_avg_mses = mean(mutated_mses)
mutated_std_mses = std(mutated_mses)

println("Mutated average: ", mutated_avg_mses)
println("Mutated standard deviation: ", mutated_std_mses)

mutated_avg_improvement = (mean_mse_initial - mutated_avg_mses) / mean_mse_initial * 100
println("Mutated improvement: ", mutated_avg_improvement, "%")

mutated_std_improvement = (std_mse_initial - mutated_std_mses) / std_mse_initial * 100
println("Mutated standard deviation improvement: ", mutated_std_improvement, "%")

println("Plotting the mutated population and the target function...")

plot(
  f, -1, 1, 
  label=L"$f(x)$", 
  lw=2, 
  tickfontsize=12, 
  legendfontsize=12, 
  guidefontsize=14
)
plot!(mutated_population[1], label=L"M(\mathrm{I}_2(x))", lw=2, ls=:dashdot)
plot!(mutated_population[2], label=L"M(\mathrm{I}_3(x))", lw=2, ls=:dash)
plot!(mutated_population[3], label=L"M(\mathrm{O}_1(x))", lw=2, ls=:dot)
plot!(mutated_population[4], label=L"M(\mathrm{O}_2(x))", lw=2, ls=:solid)
title!("Mutated individuals of the population and the target function")
xlabel!(L"$x$")
ylabel!(L"$f(x)$")
display(plot!())
png("img/theoretical_framework/gp_pop_mutation.png")  # Save the plot to a file.
