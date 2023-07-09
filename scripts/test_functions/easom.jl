using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    easom(x::Float64, y::Float64)

Calculate the Easom function, which is commonly used as a performance test
    problem for optimization algorithms.

# Arguments
- `x::Float64`: the first dimension value
- `y::Float64`: the second dimension value

# Returns
- The calculated Easom function value as a Float64.
"""
easom(x::Float64, y::Float64)::Float64 = -cos(x) * cos(y) * exp(-((x - pi)^2 + (y - pi)^2))

draw(
  x_range = -100 => 100,
  y_range = -100 => 100,
  f = easom,
  minima = [pi; pi] => [pi; pi],
  name = "easom",
)

draw(
  x_range = 0 => 2 * pi,
  y_range = 0 => 2 * pi,
  f = easom,
  minima = [pi; pi] => [pi; pi],
  name = "easom_closeup",
)
