using Plots; pythonplot()
using LaTeXStrings
using Statistics

"""
Calculates the mean squared error between the observed and predicted values.
"""
function mse(observed::Vector{Float64}, prediction::Vector{Float64})::Float64
  return sum((observed - prediction).^2) / length(observed)
end

"""
Sample points.
"""
xs = [
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

"""
Target function: 5x^3 - 2x^2 + sin(x) - 7
"""
f(x) = 5x^3 - 2x^2 + sin(x) - 7

"""
Individual 1: 3 / sin(2) * 5^3
"""
I_1(_) = 3 / sin(2) * 5^3

"""
Individual 2: 7 - (5 + sin(x))
"""
I_2(x) = 7 - (5 + sin(x))

"""
Individual 3: 7 + 2
"""
I_3(_) = 7.0 + 2

"""
Individual 4: 5 * x^2
"""
I_4(x) = 5 * x.^2

println("Plotting the population and the target function...")
plot(f, label=L"$f(x)$", lw=2)
plot!(I_1, label=L"$\mathrm{I}_1(x)$", lw=1)
plot!(I_2, label=L"$\mathrm{I}_2(x)$", lw=2, ls=:dot)
plot!(I_3, label=L"$\mathrm{I}_3(x)$", lw=2, ls=:dashdot)
plot!(I_4, label=L"$\mathrm{I}_4(x)$", lw=2, ls=:dash)
title!("Individuals of the population and the target function")
xlabel!(L"$x$")
ylabel!(L"$f(x)$")

png("img/theoretical_framework/gp_pop_init.png")  # Save the plot to a file.

"""
Mean squared errors.
"""
mses = [
  mse(f.(xs), I_1.(xs))
  mse(f.(xs), I_2.(xs))
  mse(f.(xs), I_3.(xs))
  mse(f.(xs), I_4.(xs))
]
println("Mean squared errors: ", mses)

# Save the mean squared errors to a file.
open("data/bg_gp_sym_mse_init.txt", "w") do io
  for (i, mse) in zip(eachindex(mses), mses)
    println(io, "mse(f(x), I_", i, "(x)) = ", mse)
  end
  println(io, "average = ", mean(mses))
  println(io, "std = ", std(mses))
end

"""
Corrected fitness values.
This prioritizes the individuals with the lowest mean squared error.
"""
corrected_fitness = [
  sum(mses) - mses[1]
  sum(mses) - mses[2]
  sum(mses) - mses[3]
  sum(mses) - mses[4]
]

"""
Sum of the corrected fitness values.
"""
corrected_fitness_sum = sum(corrected_fitness)

"""
Selection probabilities.
"""
probabilities = corrected_fitness / corrected_fitness_sum
println("Selection probabilities: ", probabilities)

# Save the probabilities to a file.
open("data/gp_sym_probabilities_1.txt", "w") do io
  println(io, "Individual  & Fitness & Selection Probability \\\\")
  println(io, "\\hline")
  for (i, fitness, prob) in zip(eachindex(mses), mses, probabilities)
    println(io, "\\(\\mathrm{I}_", i, "\\) & ", fitness, " & ", prob * 100, "\\% \\\\")
  end
  println(io, "\\hline")
end

println("Plotting the population and the target function...")
plot(f, -1, 1, label=L"$f(x)$", lw=2)
plot!(I_2, label=L"$\mathrm{I}_2(x)$", lw=2, ls=:dot)
plot!(I_3, label=L"$\mathrm{I}_3(x)$", lw=2, ls=:dashdot)
title!("Survivors of the population and the target function")
xlabel!(L"$x$")
ylabel!(L"$f(x)$")

png("img/theoretical_framework/gp_pop_sel_survivors.png")  # Save the plot to a file.