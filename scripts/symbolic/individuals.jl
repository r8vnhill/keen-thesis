""" Target function: 5x^3 - 2x^2 + sin(x) - 7 """
f(x) = 5x^3 - 2x^2 + sin(x) - 7

""" Initial population """
initial_individuals = [
  _ -> 3 / sin(2) * 5^3,
  x -> 7 - (5 + sin(x)),
  _ -> 7.0 + 2,
  x -> 5 * x.^2
]

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