include("../commons/mse.jl")

""" Target function: 5x^3 - 2x^2 + sin(x) - 7 """
f(x) = 5x^3 - 2x^2 + sin(x) - 7

""" Initial population """
initial_individuals = [
  _ -> 3 / sin(2) * 5^3,
  x -> 7 - (5 + sin(x)),
  _ -> 7.0 + 2,
  x -> 5 * x.^2
]

""" Initial heights """
  initial_heights = [3, 3, 1, 2]

""" Population after crossover """
crossed_individuals = [
  _ -> 3 / sin(2) * 5^3,
  x -> 7 - (5 + sin(x)),
  _ -> 7.0 + 2,
  x -> 5 * x.^2
]

""" Population after mutation """
mutated_population = [
  x -> 7 - (5 + cos(x)),
  _ -> 6 + 2,
  x -> x^3 - (5 + sin(x)),
  _ -> 6 * 7
]

"""
    create_population()

Create and initialize a population of individuals for a genetic algorithm.

  This function creates a `Population` object, which is a collection of `Individual` objects.
  Each `Individual` represents a possible solution in the search space.
  The population is initialized with a predefined list of `initial_individuals`.

  The fitness of each `Individual` is calculated as the mean squared error (MSE) between the outputs
  of the individual's function and the target function `f`, evaluated over a set of `samples`.

  Upon initialization, the function prints out the details of the population, the average fitness,
  and the standard deviation of fitness values in the population.

# Returns
  - A `Population` object representing the initial population for the genetic algorithm.
"""
function create_population()::Population
  population = Population(
    [Individual{Function}(
      initial_individuals[i], 
      L"\mathrm{I}_%$i(x)", 
      mse(f.(samples), initial_individuals[i].(samples))
    ) for i in eachindex(initial_individuals)]
  )
  @info "Initial population:\n$(repr("text/plain", population))"
  @info "Initial population average fitness: $(average_fitness(population))"
  @info "Initial population standard deviation of fitness: $(stddev_fitness(population))"
  tab = table(
    tabular(
      row(cell(bold"Generation 0", alignment = align"c", length = 4), bottom_rules = 2),
      row(bold"Individual", bold"Program", bold"Height", bold"Fitness", bottom_rules = 1),
      [row(
        population.individuals[i].name, 
        initial_heights[i],
        population.individuals[i].ϕ
      ) for i in eachindex(population.individuals)]...,
      alignment = align"c|c|c|r"
    ),
    caption = caption(
      "Initial population of the genetic programming algorithm", 
      label = "tab:bg:gp:sym:init:pop"
    ),
    position = p"ht!",
  )
  @info "Saving initial population table:\n$(repr("text/latex", tab))"
  @info "Saved initial population table to: " * 
    savetable(tab, "contents/Theoretical_Background/GP/initialization/tab-bg-gp-sym-init-pop.tex")
  return population
end
