using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    booth(x::Number, y::Number)::Number

Calculate the Booth function, which is commonly used as a performance test problem
  for optimization algorithms.

# Arguments
  - `x::Number`: the first dimension value
  - `y::Number`: the second dimension value

# Returns
  The calculated Booth function value as a Number.
"""
booth(x::Number, y::Number)::Number = (x + 2y - 7)^2 + (2x + y - 5)^2

draw(
  x_range = -10 => 10,
  y_range = -10 => 10,
  f = booth,
  minima = [1] => [3],
  name = "booth",
  log_scale = true
)