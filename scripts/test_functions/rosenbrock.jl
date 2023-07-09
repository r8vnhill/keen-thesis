using Plots; pythonplot()
using LaTeXStrings

include("../commons/draw.jl")

"""
    rosenbrock(x::Number, y::Number)

Calculate the Rosenbrock function, which is commonly used as a performance test 
  problem for optimization algorithms.

# Arguments
  - `x::Number`: the first dimension value
  - `y::Number`: the second dimension value

# Returns
  - The calculated Rosenbrock function value as a Number.
"""
rosenbrock(x::Number, y::Number)::Number = (1 - x)^2 + 100 * (y - x^2)^2

draw(
  x_range = -5 => 5,
  y_range = -5 => 5,
  f = rosenbrock,
  minima = [1] => [1],
  name = "rosenbrock",
  log_scale = true
)
