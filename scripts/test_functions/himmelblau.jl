using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    himmelblau(x::Number, y::Number)::Number

Calculate the Himmelblau function, which is commonly used as a performance test problem
  for optimization algorithms.

# Arguments
  - `x::Number`: the first dimension value
  - `y::Number`: the second dimension value

# Returns
  The calculated Himmelblau function value as a Number.
"""
himmelblau(x::Number, y::Number)::Number = (x^2 + y - 11)^2 + (x + y^2 - 7)^2

draw(
  x_range = -5 => 5,
  y_range = -5 => 5,
  f = himmelblau,
  minima = [3 => 2, -2.805118 => 3.131312, -3.779310 => -3.283186, 3.584428 => -1.848126],
  name = "himmelblau",
  log_scale = true
)
